"""
SNS24 Triage System — Web Backend
===================================
Flask + PySWIP bridge to the SWI-Prolog knowledge base.

Architecture (Stateless per-request):
  Each API call re-asserts all known facts into Prolog, then runs the
  inference engine. When the engine needs a new symptom answer it throws
  web_question_needed/1 (caught by executar_triagem_web/3 in main_web.pl),
  stores the question in pending_question/3, and returns control to Python.
  Python reads pending_question/3 and sends the question to the frontend.
  On the next request the user's answer is asserted and inference reruns.

Future LLM integration point:
  Replace the /api/chat endpoint's simple routing with an Ollama call that
  interprets free-text user input before forwarding to Prolog.
"""

import os
import uuid
import threading

from flask import Flask, request, jsonify, send_from_directory

# ── Paths ─────────────────────────────────────────────────────────────────────
BACKEND_DIR  = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR     = os.path.abspath(os.path.join(BACKEND_DIR, "..", ".."))
FRONTEND_DIR = os.path.abspath(os.path.join(BACKEND_DIR, "..", "frontend"))
MAIN_WEB_PL  = os.path.join(ROOT_DIR, "main_web.pl")

# ── Flask ─────────────────────────────────────────────────────────────────────
app = Flask(__name__, static_folder=FRONTEND_DIR, static_url_path="")

# ── PySWIP — single global Prolog engine protected by a mutex ─────────────────
# Import after Flask so startup errors are visible immediately.
from pyswip import Prolog  # noqa: E402  (import after path setup)

_prolog_lock = threading.Lock()
_prolog      = Prolog()

# SWI-Prolog resolves :- consult('...') relative to the loaded file's directory,
# so we only need the absolute path of main_web.pl here.
_pl_path = MAIN_WEB_PL.replace("\\", "/")
print(f"[SNS24] Loading Prolog knowledge base from: {_pl_path}")
_prolog.consult(_pl_path)
print("[SNS24] Prolog engine ready.")

# ── Session store ─────────────────────────────────────────────────────────────
# { session_id: {
#     "doente":           str,       Prolog patient atom
#     "grupo":            int|None,  selected symptom group (1-5)
#     "facts":            list[str], accumulated assertz strings
#     "sintoma_pendente": str|None,  last symptom asked
#     "tipo_pendente":    str,       "sn" | "escala"
#     "texto_pendente":   str,       question text for re-send on bad input
# }}
_sessions: dict[str, dict] = {}

# ── Groups menu ───────────────────────────────────────────────────────────────
GRUPOS: dict[int, str] = {
    1: "Vias Aéreas Inferiores e Pulmonares",
    2: "Contacto e Ingestão",
    3: "Reações a Fármacos e Procedimentos",
    4: "Condições Cutâneas e Infeções de Pele",
    5: "Vias Aéreas Superiores e Olhos",
}

# ── Prolog helpers ────────────────────────────────────────────────────────────

def _atom_str(value) -> str:
    """Convert a PySWIP query-result value to a plain Python string."""
    return str(value)


def _clear_patient(doente: str) -> None:
    """Remove all dynamic facts for a patient from the Prolog database."""
    list(_prolog.query(f"retractall(sintoma({doente}, _))"))
    list(_prolog.query(f"retractall(sintoma({doente}, _, _))"))
    list(_prolog.query(f"retractall(nao_sintoma({doente}, _))"))
    list(_prolog.query(f"retractall(incerto_sintoma({doente}, _))"))


def _assert_facts(facts: list[str]) -> None:
    """Assert a list of Prolog fact strings into the global database."""
    for fact in facts:
        _prolog.assertz(fact)


def _run_inference(doente: str, grupo: int) -> dict:
    """
    Run executar_triagem_web/3 and return a structured dict:

      tipo = "pergunta"    → {tipo_pergunta, sintoma, texto}
      tipo = "diagnostico" → {doenca, prioridade, acao, explicacao, probabilidade}
      tipo = "erro"        → {mensagem}
    """
    try:
        results = list(_prolog.query(
            f"executar_triagem_web({doente}, {grupo}, Status)"
        ))
    except Exception as exc:
        return {"tipo": "erro", "mensagem": f"Erro no motor Prolog: {exc}"}

    if not results:
        return {"tipo": "erro", "mensagem": "O motor de inferência não devolveu resultado."}

    status = _atom_str(results[0]["Status"])

    if status == "diagnostico_ok":
        try:
            diag = list(_prolog.query("resultado_diagnostico(D, P, A, E, Prob)"))
        except Exception as exc:
            return {"tipo": "erro", "mensagem": f"Erro ao ler diagnóstico: {exc}"}

        if diag:
            d = diag[0]
            return {
                "tipo":          "diagnostico",
                "doenca":        _atom_str(d["D"]),
                "prioridade":    _atom_str(d["P"]),
                "acao":          _atom_str(d["A"]),
                "explicacao":    _atom_str(d["E"]),
                "probabilidade": int(d["Prob"]),
            }
        return {"tipo": "erro", "mensagem": "Diagnóstico concluído mas sem resultado armazenado."}

    if status == "pergunta_necessaria":
        try:
            q = list(_prolog.query("pending_question(Tipo, Sintoma, Texto)"))
        except Exception as exc:
            return {"tipo": "erro", "mensagem": f"Erro ao ler pergunta pendente: {exc}"}

        if q:
            return {
                "tipo":          "pergunta",
                "tipo_pergunta": _atom_str(q[0]["Tipo"]),
                "sintoma":       _atom_str(q[0]["Sintoma"]),
                "texto":         _atom_str(q[0]["Texto"]),
            }
        return {"tipo": "erro", "mensagem": "Pergunta necessária mas não registada em pending_question/3."}

    return {"tipo": "erro", "mensagem": f"Estado Prolog desconhecido: '{status}'"}


# ── Routes ────────────────────────────────────────────────────────────────────

@app.route("/")
def index():
    """Serve the single-page chat frontend."""
    return send_from_directory(FRONTEND_DIR, "index.html")


@app.route("/api/start", methods=["POST"])
def start():
    """
    Initialise a new triage session.

    Returns:
        JSON with session_id and the group-selection menu.
    """
    session_id = str(uuid.uuid4())
    # Patient atom: lowercase hex, safe as a Prolog atom
    doente = f"d{session_id.replace('-', '')}"

    _sessions[session_id] = {
        "doente":           doente,
        "grupo":            None,
        "facts":            [],
        "sintoma_pendente": None,
        "tipo_pendente":    "sn",
        "texto_pendente":   "",
    }

    with _prolog_lock:
        _clear_patient(doente)

    return jsonify({
        "session_id": session_id,
        "tipo":       "menu_grupos",
        "texto": (
            "Olá! Sou o assistente de Triagem SNS24. "
            "Para iniciar, selecione o grupo de sintomas que melhor "
            "descreve o problema principal do doente:"
        ),
        "grupos": [{"id": k, "nome": v} for k, v in GRUPOS.items()],
    })


@app.route("/api/chat", methods=["POST"])
def chat():
    """
    Process one user answer and return the next question or the final diagnosis.

    Request body (JSON):
        session_id  – ID returned by /api/start
        resposta    – user answer:
                        group phase : "1" … "5"
                        sn phase    : "s" | "n" | "ns"
                        escala phase: "0" … "10"
    """
    data       = request.get_json(force=True)
    session_id = data.get("session_id", "")
    resposta   = str(data.get("resposta", "")).strip()

    if session_id not in _sessions:
        return jsonify({"tipo": "erro", "mensagem": "Sessão inválida ou expirada."}), 400

    sess   = _sessions[session_id]
    doente = sess["doente"]

    with _prolog_lock:

        # ── Phase A: group selection ───────────────────────────────────────────
        if sess["grupo"] is None:
            try:
                grupo = int(resposta)
                if grupo not in GRUPOS:
                    raise ValueError
            except (ValueError, TypeError):
                return jsonify({
                    "tipo":   "menu_grupos",
                    "texto":  "Opção inválida. Por favor escolha um número entre 1 e 5.",
                    "grupos": [{"id": k, "nome": v} for k, v in GRUPOS.items()],
                })

            sess["grupo"] = grupo
            _clear_patient(doente)          # guarantee clean slate
            result = _run_inference(doente, grupo)

            if result["tipo"] == "pergunta":
                sess["sintoma_pendente"] = result["sintoma"]
                sess["tipo_pendente"]    = result["tipo_pergunta"]
                sess["texto_pendente"]   = result["texto"]

            return jsonify(result)

        # ── Phase B: symptom questions ─────────────────────────────────────────
        grupo            = sess["grupo"]
        sintoma_pendente = sess["sintoma_pendente"]
        tipo_pendente    = sess["tipo_pendente"]
        texto_pendente   = sess["texto_pendente"]

        if sintoma_pendente:

            if tipo_pendente == "sn":
                if resposta not in ("s", "n", "ns"):
                    # Re-send the same question with an error hint
                    return jsonify({
                        "tipo":          "pergunta",
                        "tipo_pergunta": "sn",
                        "sintoma":       sintoma_pendente,
                        "texto":         texto_pendente,
                        "erro":          "Resposta inválida. Use s (sim), n (não) ou ns (não sei).",
                    })

                if resposta == "s":
                    fact = f"sintoma({doente}, {sintoma_pendente})"
                elif resposta == "n":
                    fact = f"nao_sintoma({doente}, {sintoma_pendente})"
                else:
                    fact = f"incerto_sintoma({doente}, {sintoma_pendente})"
                sess["facts"].append(fact)

            else:  # escala
                try:
                    val = int(resposta)
                    if not 0 <= val <= 10:
                        raise ValueError
                except (ValueError, TypeError):
                    return jsonify({
                        "tipo":          "pergunta",
                        "tipo_pergunta": "escala",
                        "sintoma":       sintoma_pendente,
                        "texto":         texto_pendente,
                        "erro":          "Valor inválido. Introduza um número inteiro entre 0 e 10.",
                    })
                sess["facts"].append(f"sintoma({doente}, {sintoma_pendente}, {val})")

        # Re-run inference from scratch with all accumulated facts asserted
        _clear_patient(doente)
        _assert_facts(sess["facts"])
        result = _run_inference(doente, grupo)

        # Persist pending question state for validation on the next call
        if result["tipo"] == "pergunta":
            sess["sintoma_pendente"] = result["sintoma"]
            sess["tipo_pendente"]    = result["tipo_pergunta"]
            sess["texto_pendente"]   = result["texto"]
        else:
            sess["sintoma_pendente"] = None

        return jsonify(result)


@app.route("/api/reset", methods=["POST"])
def reset():
    """
    End a triage session: remove all Prolog facts asserted for the patient
    and delete the session from the server-side store.
    """
    data       = request.get_json(force=True)
    session_id = data.get("session_id", "")

    sess = _sessions.pop(session_id, None)
    if sess:
        with _prolog_lock:
            _clear_patient(sess["doente"])

    return jsonify({"ok": True})


# ── Entry point ───────────────────────────────────────────────────────────────
if __name__ == "__main__":
    # Single-threaded to avoid concurrent Prolog state conflicts.
    # For production: waitress-serve --port=5000 app:app
    app.run(debug=False, host="127.0.0.1", port=5000, threaded=False)
