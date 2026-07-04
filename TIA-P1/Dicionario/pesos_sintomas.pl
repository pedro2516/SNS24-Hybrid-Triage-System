:- encoding(utf8).

% =====================================================================
% PESOS DAS PERGUNTAS (SISTEMA PROBABILISTICO)
% Define a gravidade relativa de cada sintoma para o calculo da
% probabilidade do quadro clinico. Sintomas de risco de vida tem
% pesos muito elevados (30-50). Os restantes assumem o padrao (10).
% =====================================================================

:- discontiguous peso_sintoma/2. % Aqui pode continuar discontiguous pois fica num só ficheiro

% --- Choque / Falencia (Peso Maximo) ---
peso_sintoma(sufoco_iminente,                       50).
peso_sintoma(lingua_bloqueia_passagem_ar,           50).
peso_sintoma(perda_de_consciencia,                  50).
peso_sintoma(desmaio,                               50).
peso_sintoma(perda_consciencia,                     50).
peso_sintoma(tonturas_extremas_ou_desmaio,          45).
peso_sintoma(dificuldade_em_respirar_ou_engolir,    45).
peso_sintoma(falta_de_ar_extrema,                   45).
peso_sintoma(incapacidade_falar,                    45).
peso_sintoma(cianose_labios_unhas,                  45).
peso_sintoma(pele_ligeiramente_azul,                45).
peso_sintoma(palidez_extrema,                       45).
peso_sintoma(dificuldade_subita_respirar,           40).
peso_sintoma(inchaco_garganta,                      40).
peso_sintoma(inchaco_lingua_garganta,               40).

% --- Emergencias Severas / Precursores de Choque ---
peso_sintoma(voz_rouca_subita,                      35).
peso_sintoma(dificuldade_respirar_chiadeira,        35).
peso_sintoma(falta_de_ar_em_repouso,                35).
peso_sintoma(dor_toracica,                          35).
peso_sintoma(tosse_sangue,                          35).
peso_sintoma(inchaco_rapido_labios,                 35).
peso_sintoma(inchaco_rapido_lingua,                 35).
peso_sintoma(urticaria_generalizada,                30).
peso_sintoma(urticaria_generalizada_subita,         30).
peso_sintoma(peito_esmagado,                        30).
peso_sintoma(coracao_descontrolado,                 30).
peso_sintoma(vomitos_repetidos,                     30).
peso_sintoma(dificuldade_engolir_saliva,            30).
peso_sintoma(olhos_inchados_fechados,               30).
peso_sintoma(perda_subita_visao_turva,              30).
peso_sintoma(alteracao_da_visao,                    30).
peso_sintoma(febre_alta_provocada_erupcao,          30).
peso_sintoma(bolhas_grande_parte_corpo,             30).

% Regra de fallback: qualquer sintoma nao listado tem peso padrao de 10.
obter_peso(Sintoma, Peso) :-
    peso_sintoma(Sintoma, Peso), !.
obter_peso(_, 10).