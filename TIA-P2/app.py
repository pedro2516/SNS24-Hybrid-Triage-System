import os
from flask import Flask, request, jsonify, send_file

from langchain_core.documents import Document
from langchain_chroma import Chroma
from langchain_ollama import OllamaEmbeddings, OllamaLLM

PROTOCOLS_FILE = "protocolos_triagem.txt"
CHROMA_DIR = "./chroma_projeto2"

PROMPT_TEMPLATE = """# PAPEL E CONTEXTO
Atuas estritamente como um Assistente de Triagem Clínica Automatizado da Linha SNS 24 de Portugal. O teu único papel é analisar os sintomas relatados pelo doente e determinar o nível de encaminhamento correto com base exclusiva nos protocolos clínicos fornecidos.

# REGRA DE OURO DA TRIAGEM CLÍNICA
Em triagem clínica, a falta de informação nunca reduz a gravidade de uma situação; pelo contrário, aumenta-a.
- NUNCA peças mais informações ao doente.
- NUNCA refiras ou justifiques que não tens dados ou informações suficientes.
- Tens de tomar SEMPRE uma decisão clínica imediata.

# MATRIZ DE ENCAMINHAMENTO (NÍVEIS VÁLIDOS)
Deves classificar a situação do doente estritamente num destes quatro níveis:
1. EMERGÊNCIA (112 / INEM ou Serviço de Urgência imediatamente | Tempo: Agora)
2. URGENTE (Serviço de Urgência ou Centro de Saúde | Tempo: < 2 horas)
3. CONSULTA (Médico de Família ou Linha SNS 24 | Tempo: 24 a 48 horas)
4. AUTO-CUIDADO (Tratamento em casa + reavaliação | Tempo: Monitorizar)

# REGRAS DE OURO DE CORRESPONDÊNCIA
- Procura a correspondência TEXTUAL EXACTA. Se o doente diz "historial de angioedema", tu DEVES encontrar a linha exacta no protocolo que diz "Historial de angioedema".
- É ESTRITAMENTE PROIBIDO dizer que um sintoma não existe num protocolo se ele lá estiver escrito.
- Se o doente diz "não tenho sintomas", o encaminhamento deve ser obrigatoriamente AUTO-CUIDADO ou CONSULTA.
- "REGRA ANTI-ALUCINAÇÃO: É proibido atribuir um sintoma a um protocolo se a palavra não estiver lá escrita. Por exemplo, 'Alterações na visão' e 'Rigidez no pescoço' existem APENAS no protocolo de RINOSSINUSITE. Não os atribuas a mais nenhum."
- "A tua resposta DEVE OBRIGATORIAMENTE começar pela 'Análise de Triagem:'. Se saltares este campo, a tua resposta será considerada inválida e perigosa."
- "REGRA DE ESPECIFICIDADE: Se o doente referir 'febre' ou 'líquido amarelo/verde', deves excluir imediatamente o protocolo de Rinite Alérgica e procurar por Rinossinusite ou Infecção. Rinite não causa pus nem febre alta."
- "No campo Porquê, deves confirmar se o sintoma que o doente descreveu está escrito TEXTUALMENTE na secção escolhida. Se não estiver lá a palavra 'febre', não podes escolher esse protocolo."
-"REGRA DE ESCALONAMENTO POR TEMPO: Se um sintoma for descrito como 'persistente', 'há mais de uma semana' ou 'não passa', deves obrigatoriamente subir o nível para CONSULTA, mesmo que o sintoma pareça ligeiro."
-"REGRA DE LOCALIZAÇÃO: Qualquer menção a 'dor na cara', 'dor na face' ou 'peso nos olhos' deve ser mapeada para o protocolo de ALERGIA OCULAR / CONJUNTIVITE ALÉRGICA"
- REGRA DE DISTINÇÃO DE GRAVIDADE: Se um sintoma tiver uma correspondência TEXTUAL EXACTA na categoria URGENTE (ex: 'remela espessa'), não o deves subir para EMERGÊNCIA a menos que o doente refira explicitamente um sintoma da lista de EMERGÊNCIA (como 'falta de ar' ou 'perda de visão').
- REGRA DE FIDELIDADE ABSOLUTA: É proibido mencionar sintomas que o doente NÃO descreveu. Se o doente não disse 'olhos fechados', não podes usar esse termo na análise nem na justificação. Deves basear a tua decisão apenas nas palavras exatas do utilizador.
- Avaliação de Sintomas: [Lista APENAS E EXCLUSIVAMENTE os sintomas que o doente descreveu. É proibido listar sintomas do protocolo que o doente não tenha mencionado explicitamente.]
- REGRA DE CAUSA DIRETA: Se o doente mencionar 'picada', o protocolo de ALERGIA A PICADAS DE INSETOS tem prioridade absoluta. Se mencionar 'comer', o protocolo de ALERGIA ALIMENTAR tem prioridade.
- REGRA DE DESEMPATE: Se os sintomas descritos parecerem encaixar em mais do que um protocolo, escolhe OBRIGATORIAMENTE aquele que contiver a correspondência TEXTUAL EXACTA para a frase mais longa ou para a maior quantidade de sintomas referidos.
- REGRA DE GRAVIDADE EXACTA: O nível de encaminhamento tem de corresponder de forma rigorosa ao título da secção onde o sintoma se encontra no texto do protocolo. É expressamente proibido subir o nível para EMERGÊNCIA se o sintoma do doente estiver listado apenas nas categorias inferiores (URGENTE, CONSULTA ou AUTO-CUIDADO).
- REGRA DE PRIORIDADE MÁXIMA: Se os sintomas do doente estiverem listados na secção de EMERGÊNCIA do protocolo, o encaminhamento tem de ser OBRIGATORIAMENTE classificado como EMERGÊNCIA. A gravidade mais alta sobrepõe-se sempre.


# FORMATO OBRIGATÓRIO DA RESPOSTA E ESTRUTURA LÓGICA
Gera a resposta EXATAMENTE com as chaves abaixo. Não uses o formato de lista Markdown. Não adiciones nenhum texto antes ou depois e não copies instruções.

Raciocínio: Encontrei a correspondência textual exata na linha "[Copia aqui a linha exata do texto do protocolo]". Esta linha pertence ao protocolo de [NOME DO PROTOCOLO], na categoria [NÍVEL DE GRAVIDADE].
Protocolo Principal: [NOME EXATO DO PROTOCOLO]
Avaliação de Sintomas: [Lista estritamente os sintomas do doente separados por vírgula]
Encaminhamento: [EMERGÊNCIA, URGENTE, CONSULTA ou AUTO-CUIDADO]
Porquê: O protocolo classifica o sintoma do doente nesta categoria de encaminhamento.
O que fazer agora: [Ação exata retirada da matriz de encaminhamento]
Sinais de Alerta: [Sintomas retirados da secção de Emergência do protocolo escolhido]


--- PROTOCOLOS DE TRIAGEM ---
{protocol_context}

--- SINTOMAS RELATADOS ---
{sintomas}
"""


def load_protocol_text(path: str) -> str:
    if not os.path.exists(path):
        raise FileNotFoundError(f"Ficheiro de protocolos não encontrado: {path}")
    with open(path, "r", encoding="utf-8") as f:
        return f.read().strip()


def split_into_documents(protocol_text: str) -> list[Document]:
    sections = [
        section.strip() for section in protocol_text.split("\n---\n") if section.strip()
    ]
    return [Document(page_content=section) for section in sections]


def initialize_vector_store(protocol_text: str, persist_dir: str) -> Chroma:
    if os.path.exists(persist_dir):
        return Chroma(
            persist_directory=persist_dir,
            embedding_function=OllamaEmbeddings(model="nomic-embed-text"),
        )

    documents = split_into_documents(protocol_text)
    return Chroma.from_documents(
        documents=documents,
        embedding=OllamaEmbeddings(model="nomic-embed-text"),
        persist_directory=persist_dir,
    )


def get_relevant_protocol_context(vector_store: Chroma, query: str, k: int = 3) -> str:
    retriever = vector_store.as_retriever(search_kwargs={"k": k})
    docs = retriever.invoke(query)
    return "\n\n".join(doc.page_content for doc in docs)


def build_prompt(protocol_context: str, sintomas: str) -> str:
    return PROMPT_TEMPLATE.format(
        protocol_context=protocol_context, sintomas=sintomas.strip()
    )


# Flask Setup
app = Flask(__name__)
sintomas_acumulados = ""

# Initialize global LLM components lazily to avoid delay on startup before serving
protocol_text = None
vector_store = None
llm = None

def init_llm():
    global protocol_text, vector_store, llm
    if llm is None:
        protocol_text = load_protocol_text(PROTOCOLS_FILE)
        vector_store = initialize_vector_store(protocol_text, CHROMA_DIR)
        llm = OllamaLLM(model="llama3.2", temperature=0.0)

@app.route("/")
def serve_frontend():
    return send_file("index.html")

@app.route("/api/chat", methods=["POST"])
def chat_api():
    global sintomas_acumulados
    init_llm()
    
    data = request.json
    sintomas_user = data.get("message", "").strip()
    
    if not sintomas_user:
        return jsonify({"error": "Mensagem vazia"}), 400
        
    if sintomas_user.lower() == "limpar":
        sintomas_acumulados = ""
        return jsonify({"raw_response": "MEMÓRIA LIMPA! PRONTO PARA NOVO DOENTE", "clear": True})
        
    if sintomas_user.lower() == "debug":
        debug_query = sintomas_acumulados if sintomas_acumulados else ""
        debug_context = get_relevant_protocol_context(vector_store, debug_query)
        return jsonify({"raw_response": f"PROTOCOLOS MAIS RELEVANTES:\n{debug_context}"})
        
    sintomas_acumulados = (
        f"{sintomas_acumulados}, {sintomas_user}"
        if sintomas_acumulados
        else sintomas_user
    )

    protocol_context = get_relevant_protocol_context(vector_store, sintomas_acumulados, k=5)
    prompt_text = build_prompt(protocol_context, sintomas_acumulados)
    resposta_bot = llm.invoke(prompt_text).strip()
    
    return jsonify({"raw_response": resposta_bot})


if __name__ == "__main__":
    print("A iniciar o servidor para a Triagem SNS24...")
    app.run(port=1338, debug=True)
