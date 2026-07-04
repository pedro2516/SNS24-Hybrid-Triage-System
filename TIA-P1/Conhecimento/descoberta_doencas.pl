:- encoding(utf8).

% ========================================================================
% DESCOBERTA DE DOENÇAS (MAPEAMENTO DE SINTOMAS -> PROTOCOLO)
% ========================================================================

% --- CAMINHOS GERAIS (Para quando se corre diagnosticar/1 sem Weka) ---
triagem(Doente, Doenca, Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, queixas_respiratorias),
    encaminhar_respiratorio(Doente, Doenca, Prioridade, Acao, Explicacao).

triagem(Doente, Doenca, Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, queixas_na_pele),
    encaminhar_pele(Doente, Doenca, Prioridade, Acao, Explicacao).

triagem(Doente, Doenca, Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, queixas_medicamentosas),
    encaminhar_medicamento(Doente, Doenca, Prioridade, Acao, Explicacao).

triagem(Doente, 'Alergia Ocular', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, queixas_oculares),
    triagem_ocular(Doente, Prioridade, Acao, Explicacao).

triagem(Doente, 'Alergia Alimentar', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, queixas_alimentares),
    triagem_alimentar(Doente, Prioridade, Acao, Explicacao).

triagem(Doente, 'Alergia a Animais de Estimacao', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, suspeita_exposicao_animais),
    triagem_animais(Doente, Prioridade, Acao, Explicacao).

triagem(Doente, 'Alergia a Picada de Inseto', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, queixas_picadas_insetos),
    triagem_insetos(Doente, Prioridade, Acao, Explicacao).

triagem(Doente, 'Alergia ao Latex', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, suspeita_exposicao_latex),
    triagem_latex(Doente, Prioridade, Acao, Explicacao).

triagem(Doente, 'Anafilaxia Severa', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, suspeita_anafilaxia),
    triagem_anafilaxia(Doente, Prioridade, Acao, Explicacao).

triagem(Doente, 'Angioedema', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, suspeita_angioedema),
    triagem_angioedema(Doente, Prioridade, Acao, Explicacao).

triagem(_, 'Desconhecida', _, 'Aconselhamento Linha SNS24', 'Nao foi possivel determinar o protocolo.').

% --- AUXILIARES DE ENCAMINHAMENTO ---
encaminhar_respiratorio(Doente, 'Asma', Prioridade, Acao, Explicacao) :-
    (tem_sintoma(Doente, historico_asma) ; tem_sintoma(Doente, falta_de_ar_com_pieira)) , triagem_asma(Doente, Prioridade, Acao, Explicacao).

encaminhar_respiratorio(Doente, 'Rinossinusite', Prioridade, Acao, Explicacao) :-
    (tem_sintoma(Doente, dor_na_face) ; tem_sintoma(Doente, nariz_entupido) ; tem_sintoma(Doente, corrimento_amarelo)) , triagem_rinossinusite(Doente, Prioridade, Acao, Explicacao).

encaminhar_respiratorio(Doente, 'Rinite Alergica', Prioridade, Acao, Explicacao) :-
    (tem_sintoma(Doente, espirros_frequentes) ; tem_sintoma(Doente, comichao_no_nariz)) , triagem_rinite(Doente, Prioridade, Acao, Explicacao).

encaminhar_respiratorio(Doente, 'Aspergilose Broncopulmonar (ABPA)', Prioridade, Acao, Explicacao) :-
    (tem_sintoma(Doente, tosse) , tem_sintoma(Doente, muco_castanho)) , triagem_abpa(Doente, Prioridade, Acao, Explicacao).

encaminhar_pele(Doente, 'Urticaria', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, manchas_com_muita_comichao) , triagem_urticaria(Doente, Prioridade, Acao, Explicacao).

encaminhar_pele(Doente, 'Dermatite', Prioridade, Acao, Explicacao) :-
    (tem_sintoma(Doente, pele_cronicamente_seca) ; tem_sintoma(Doente, pele_com_descamacao)) , triagem_dermatite(Doente, Prioridade, Acao, Explicacao).

encaminhar_medicamento(Doente, 'Alergia a Penicilina', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, tomou_penicilina) , triagem_penicilina(Doente, Prioridade, Acao, Explicacao).

encaminhar_medicamento(Doente, 'Alergia a AINEs (Anti-inflamatorios)', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, tomou_anti_inflamatorio) , triagem_aines(Doente, Prioridade, Acao, Explicacao).

encaminhar_medicamento(Doente, 'Alergia a Anestesicos', Prioridade, Acao, Explicacao) :-
    tem_sintoma(Doente, anestesia_recentemente) , triagem_anestesicos(Doente, Prioridade, Acao, Explicacao).


% ========================================================================
% ROTEAMENTO DIRECIONADO (OTIMIZADO COM FAST-TRACK E SILENCIO)
% ========================================================================

% Auxiliar: Verifica a memoria do Weka SEM disparar novas perguntas.
sintoma_confirmado(Doente, Sintoma) :- sintoma(Doente, Sintoma).
sintoma_confirmado(Doente, Sintoma) :- sintoma(Doente, Sintoma, V), V >= 5.

% -----------------------------------------
% 1. FAST-TRACK: Se o Weka ja encontrou um sintoma chave, salta direto para a doenca!
% O simbolo "!" (cut) garante que nao faz mais perguntas genéricas.
% -----------------------------------------
% GRUPO 1
descobrir_doenca_por_grupo(Doente, 1, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, tosse_persistente_noturna) ; sintoma_confirmado(Doente, uso_frequente_inalador)), !, 
    Doenca = 'Asma', triagem_asma(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 1, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, peito_pesado_ambientes_humidos) ; sintoma_confirmado(Doente, muco_castanho)), !, 
    Doenca = 'Aspergilose Broncopulmonar (ABPA)', triagem_abpa(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 1, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, manchas_secas_asperas) ; sintoma_confirmado(Doente, comichao_cara_garganta)), !, 
    Doenca = 'Alergia a Animais de Estimacao', triagem_animais(Doente, Prioridade, Acao, Explicacao).

% GRUPO 2
descobrir_doenca_por_grupo(Doente, 2, Doenca, Prioridade, Acao, Explicacao) :-
    sintoma_confirmado(Doente, historico_anafilaxia), !, 
    Doenca = 'Anafilaxia Severa', triagem_anafilaxia(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 2, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, sintomas_apos_ingestao) ; sintoma_confirmado(Doente, lacrimejo_apos_comer)), !, 
    Doenca = 'Alergia Alimentar', triagem_alimentar(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 2, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, comichao_local_picada) ; sintoma_confirmado(Doente, picada_piorou_24h)), !, 
    Doenca = 'Alergia a Picada de Inseto', triagem_insetos(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 2, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, reacao_local_zona_latex) ; sintoma_confirmado(Doente, alergia_local_trabalho)), !, 
    Doenca = 'Alergia ao Latex', triagem_latex(Doente, Prioridade, Acao, Explicacao).

% GRUPO 3
descobrir_doenca_por_grupo(Doente, 3, Doenca, Prioridade, Acao, Explicacao) :-
    sintoma_confirmado(Doente, pequenas_alteracoes_cutaneas_isoladas), !, 
    Doenca = 'Alergia a Penicilina', triagem_penicilina(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 3, Doenca, Prioridade, Acao, Explicacao) :-
    sintoma_confirmado(Doente, comichao_ligeira_tardio_apos_tomar_farmaco), !, 
    Doenca = 'Alergia a AINEs (Anti-inflamatorios)', triagem_aines(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 3, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, vermelidao_local_persistente) ; sintoma_confirmado(Doente, dormencia_prolongada_sem_dor)), !, 
    Doenca = 'Alergia a Anestesicos', triagem_anestesicos(Doente, Prioridade, Acao, Explicacao).

% GRUPO 4
descobrir_doenca_por_grupo(Doente, 4, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, pele_empolada) ; sintoma_confirmado(Doente, pequenas_manchas_menos_24h)), !, 
    Doenca = 'Urticaria', triagem_urticaria(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 4, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, inchaco_rosto) ; sintoma_confirmado(Doente, labio_inchado)), !, 
    Doenca = 'Angioedema', triagem_angioedema(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 4, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, pele_muito_seca) ; sintoma_confirmado(Doente, vermelhidao_persistente_nas_dobras)), !, 
    Doenca = 'Dermatite', triagem_dermatite(Doente, Prioridade, Acao, Explicacao).

% GRUPO 5
descobrir_doenca_por_grupo(Doente, 5, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, peso_na_face) ; sintoma_confirmado(Doente, dor_na_face) ; sintoma_confirmado(Doente, sintomas_congestao)), !, 
    Doenca = 'Rinossinusite', triagem_rinossinusite(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 5, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, comichao_vermelidao_48h) ; sintoma_confirmado(Doente, palpebras_inchadas) ; sintoma_confirmado(Doente, comichao_intensa_ambos_olhos)), !, 
    Doenca = 'Alergia Ocular', triagem_ocular(Doente, Prioridade, Acao, Explicacao).
descobrir_doenca_por_grupo(Doente, 5, Doenca, Prioridade, Acao, Explicacao) :-
    (sintoma_confirmado(Doente, espirros_frequentes) ; sintoma_confirmado(Doente, corrimento_claro) ; sintoma_confirmado(Doente, comichao_no_nariz)), !, 
    Doenca = 'Rinite Alergica', triagem_rinite(Doente, Prioridade, Acao, Explicacao).

% -----------------------------------------
% 2. FALLBACK: Se o Weka nao apanhou nada claro (doente disse Nao a tudo), 
% fazemos as perguntas diretas para tentar afunilar o problema.
% -----------------------------------------
descobrir_doenca_por_grupo(Doente, 1, Doenca, Prioridade, Acao, Explicacao) :-
    ( (tem_sintoma(Doente, historico_asma) ; tem_sintoma(Doente, falta_de_ar_com_pieira)), Doenca = 'Asma', triagem_asma(Doente, Prioridade, Acao, Explicacao) ) ;
    ( (tem_sintoma(Doente, tosse) , tem_sintoma(Doente, muco_castanho)), Doenca = 'Aspergilose Broncopulmonar (ABPA)', triagem_abpa(Doente, Prioridade, Acao, Explicacao) ) ;
    ( tem_sintoma(Doente, suspeita_exposicao_animais), Doenca = 'Alergia a Animais de Estimacao', triagem_animais(Doente, Prioridade, Acao, Explicacao) ).

descobrir_doenca_por_grupo(Doente, 2, Doenca, Prioridade, Acao, Explicacao) :-
    ( tem_sintoma(Doente, suspeita_anafilaxia), Doenca = 'Anafilaxia Severa', triagem_anafilaxia(Doente, Prioridade, Acao, Explicacao) ) ;
    ( tem_sintoma(Doente, queixas_alimentares), Doenca = 'Alergia Alimentar', triagem_alimentar(Doente, Prioridade, Acao, Explicacao) ) ;
    ( tem_sintoma(Doente, queixas_picadas_insetos), Doenca = 'Alergia a Picada de Inseto', triagem_insetos(Doente, Prioridade, Acao, Explicacao) ) ;
    ( tem_sintoma(Doente, suspeita_exposicao_latex), Doenca = 'Alergia ao Latex', triagem_latex(Doente, Prioridade, Acao, Explicacao) ).

descobrir_doenca_por_grupo(Doente, 3, Doenca, Prioridade, Acao, Explicacao) :-
    ( tem_sintoma(Doente, tomou_penicilina), Doenca = 'Alergia a Penicilina', triagem_penicilina(Doente, Prioridade, Acao, Explicacao) ) ;
    ( tem_sintoma(Doente, tomou_anti_inflamatorio), Doenca = 'Alergia a AINEs (Anti-inflamatorios)', triagem_aines(Doente, Prioridade, Acao, Explicacao) ) ;
    ( tem_sintoma(Doente, anestesia_recentemente), Doenca = 'Alergia a Anestesicos', triagem_anestesicos(Doente, Prioridade, Acao, Explicacao) ).

descobrir_doenca_por_grupo(Doente, 4, Doenca, Prioridade, Acao, Explicacao) :-
    ( tem_sintoma(Doente, manchas_com_muita_comichao), Doenca = 'Urticaria', triagem_urticaria(Doente, Prioridade, Acao, Explicacao) ) ;
    ( tem_sintoma(Doente, suspeita_angioedema), Doenca = 'Angioedema', triagem_angioedema(Doente, Prioridade, Acao, Explicacao) ) ;
    ( (tem_sintoma(Doente, pele_cronicamente_seca) ; tem_sintoma(Doente, pele_com_descamacao)), Doenca = 'Dermatite', triagem_dermatite(Doente, Prioridade, Acao, Explicacao) ).

descobrir_doenca_por_grupo(Doente, 5, Doenca, Prioridade, Acao, Explicacao) :-
    ( (tem_sintoma(Doente, dor_na_face) ; tem_sintoma(Doente, nariz_entupido)), Doenca = 'Rinossinusite', triagem_rinossinusite(Doente, Prioridade, Acao, Explicacao) ) ;
    ( tem_sintoma(Doente, queixas_oculares), Doenca = 'Alergia Ocular', triagem_ocular(Doente, Prioridade, Acao, Explicacao) ) ;
    ( (tem_sintoma(Doente, espirros_frequentes) ; tem_sintoma(Doente, comichao_no_nariz)), Doenca = 'Rinite Alergica', triagem_rinite(Doente, Prioridade, Acao, Explicacao) ).