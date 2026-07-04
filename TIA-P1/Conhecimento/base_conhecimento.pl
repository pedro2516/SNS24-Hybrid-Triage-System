:- encoding(utf8).

% ===================================================
% BASE DE CONHECIMENTO: PROTOCOLOS DE TRIAGEM
% Cada protocolo define quatro niveis de prioridade:
%   emergencia   - risco de vida imediato (ligar 112)
%   urgente      - avaliacao medica nas proximas 24h
%   nao_urgente  - consulta no centro de saude
%   autocuidados - gestao em casa com vigilancia
% ===================================================

% =======================
% --- PROTOCOLO: ASMA ---
% =======================
triagem_asma(Doente, emergencia, 'Acionar 112 (INEM)', 'Falencia respiratoria iminente.') :-
    tem_sintoma(Doente, cianose_labios_unhas) ;
    tem_sintoma(Doente, incapacidade_falar) ;
    (sintoma(Doente, dificuldade_respirar_agora, V), V >= 8).

triagem_asma(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Crise moderada.') :-
    not(tem_sintoma(Doente, cianose_labios_unhas)),
    not(tem_sintoma(Doente, incapacidade_falar)),
    (   (sintoma(Doente, dificuldade_respirar_agora, V), V >= 5, V < 8) ; 
        (tem_sintoma(Doente, falta_de_ar_com_pieira) , tem_sintoma(Doente, tosse_persistente))
    ).

triagem_asma(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Sintomas cronicos que indicam falta de controlo.') :-
    not(tem_sintoma(Doente, falta_de_ar_com_pieira)),
    (sintoma(Doente, dificuldade_respirar_agora, V), V < 5),
    (   tem_sintoma(Doente, tosse_persistente) ;
        tem_sintoma(Doente, tosse_persistente_noturna) ;
        tem_sintoma(Doente, uso_frequente_inalador)
    ).

triagem_asma(Doente, autocuidados, 'Autocuidados em casa', 'Quadro clinico ligeiro e estavel.') :-
    tem_sintoma(Doente, fala_normal),
    not(tem_sintoma(Doente, tosse_persistente)),
    (   tem_sintoma(Doente, tosse_ligeira) ; 
        tem_sintoma(Doente, comichao_garganta)
    ).

% ================================
% --- PROTOCOLO: RINOSSINUSITE ---
% ================================
triagem_rinossinusite(Doente, emergencia, 'Acionar 112 ou ida imediata a Urgencia Hospitalar', 'Estes sinais indicam um risco elevado de a infecao se espalhar para o Sistema Nervoso Central ou causar danos oculares permanentes.') :-
    tem_sintoma(Doente, alteracao_da_visao) ;
    (sintoma(Doente, rigidez_no_pescoco, V1), V1 >= 8) ;
    (sintoma(Doente, inchaco_nos_olhos, V2), V2 >= 8).

triagem_rinossinusite(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Sugere uma Rinossinusite Aguda ou Infetada que necessita de avaliacao medica rapida.') :-
    not(tem_sintoma(Doente, alteracao_da_visao)),
    not((sintoma(Doente, rigidez_no_pescoco, Vr), Vr >= 8)),
    not((sintoma(Doente, inchaco_nos_olhos, Vi), Vi >= 8)),
    (   tem_sintoma(Doente, febre_alta) ; 
        tem_sintoma(Doente, febre_persistente) ;
        (sintoma(Doente, corrimento_purulento, V3), V3 >= 5) ;
        (sintoma(Doente, dor_facial, V4), V4 >= 5)
    ).

triagem_rinossinusite(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Sintomas persistentes que requerem diagnostico programado, mas sem sinais de gravidade aguda.') :-
    tem_sintoma(Doente, sintomas_congestao),
    not(tem_sintoma(Doente, febre_alta)),
    not(tem_sintoma(Doente, febre_persistente)),
    (sintoma(Doente, dor_facial, V5), V5 < 5).

triagem_rinossinusite(Doente, autocuidados, 'Autocuidados em casa', 'Quadro de Rinossinusite Ligeira ou Congestiva, gerivel com medidas de conforto.') :-
    not(tem_sintoma(Doente, sintomas_congestao)),
    (   tem_sintoma(Doente, nariz_entupido) ;
        tem_sintoma(Doente, peso_na_face) ;
        tem_sintoma(Doente, corrimento_claro)
    ).

% ==================================
% --- PROTOCOLO: RINITE ALERGICA ---
% ==================================
triagem_rinite(Doente, emergencia, 'Acionar 112 (INEM)', 'A rinite evoluiu para um quadro de anafilaxia ou crise de asma grave.') :-
    (sintoma(Doente, dificuldade_respiratoria, V1), V1 >= 8) ;
    tem_sintoma(Doente, inchaco_visivel_na_garganta) ;
    (sintoma(Doente, febre, V2), V2 >= 8).

triagem_rinite(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Indica uma agudizacao que requer avaliacao medica celere para evitar agravamento.') :-
    not(tem_sintoma(Doente, inchaco_visivel_na_garganta)),
    not((sintoma(Doente, dificuldade_respiratoria, Vd), Vd >= 8)),
    not((sintoma(Doente, febre, Vf), Vf >= 8)),
    (   (sintoma(Doente, dificuldade_respiratoria, V1), V1 >= 5, V1 < 8) ;
        (sintoma(Doente, dor_facial, V2), V2 >= 5) ;
        (sintoma(Doente, febre, V3), V3 >= 5, V3 < 8)
    ).

triagem_rinite(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Sintomas que sugerem que a alergia pode estar a afetar os bronquios ou a causar lesoes na mucosa nasal.') :-
    not((sintoma(Doente, febre, Vf), Vf >= 5)),
    not((sintoma(Doente, dor_facial, Vdf), Vdf >= 5)),
    (   tem_sintoma(Doente, sintomas_impedem_sono) ;
        (sintoma(Doente, tosse_noturna, V4), V4 >= 5) ;
        tem_sintoma(Doente, sangramento_nasal_frequente)
    ).

triagem_rinite(Doente, autocuidados, 'Autocuidados em casa', 'Quadro clinico classico de rinite ligeira, gerivel com medidas de higiene e controlo ambiental.') :-
    not(tem_sintoma(Doente, sintomas_impedem_sono)),
    not(tem_sintoma(Doente, sangramento_nasal_frequente)),
    (   tem_sintoma(Doente, espirros_frequentes) ;
        (sintoma(Doente, comichao_nariz, V5), V5 >= 0) ;
        (sintoma(Doente, comichao_olhos, V6), V6 >= 0) ;
        tem_sintoma(Doente, comichao_garganta) ;
        tem_sintoma(Doente, corrimento_nasal)
    ).

% =======================================
% --- PROTOCOLO: ALERGIA A PENICILINA ---
% =======================================
triagem_penicilina(Doente, emergencia, 'Acionar 112 (INEM) imediatamente', 'Quadro de anafilaxia (reacao sistemica grave) com risco de paragem respiratoria ou choque.') :-
    tem_sintoma(Doente, dificuldade_subita_respirar) ; 
    tem_sintoma(Doente, dificuldade_subita_pieira) ; 
    tem_sintoma(Doente, dificuldade_subita_aperto_peito) ;
    tem_sintoma(Doente, inchaco_rapido_labios) ; 
    tem_sintoma(Doente, inchaco_rapido_lingua) ;
    tem_sintoma(Doente, tonturas_extremas_ou_desmaio) ;
    tem_sintoma(Doente, urticaria_generalizada_subita) ;
    (sintoma(Doente, falta_de_ar, V1), V1 >= 8).

triagem_penicilina(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Reacao moderada que requer medicacao forte, mas sem compromisso vital imediato.') :-
    not(tem_sintoma(Doente, dificuldade_subita_respirar)),
    not(tem_sintoma(Doente, dificuldade_subita_pieira)),
    not(tem_sintoma(Doente, dificuldade_subita_aperto_peito)),
    not(tem_sintoma(Doente, inchaco_rapido_labios)),
    not(tem_sintoma(Doente, inchaco_rapido_lingua)),
    not(tem_sintoma(Doente, tonturas_extremas_ou_desmaio)),
    not(tem_sintoma(Doente, urticaria_generalizada_subita)),
    (   tem_sintoma(Doente, urticaria_espalha_grandes_areas) ;
        (tem_sintoma(Doente, febre) , tem_sintoma(Doente, manchas_ligeiras)) ;
        (sintoma(Doente, dor_inchaco_articulacoes, V2), V2 >= 5) ;
        (sintoma(Doente, falta_de_ar, V3), V3 >= 5, V3 < 8)
    ).

triagem_penicilina(Doente, nao_urgente, 'Contactar Medico Prescritor ou Centro de Saude', 'Reacao cutanea tardia comum. Requer confirmacao medica.') :-
    tem_sintoma(Doente, manchas_ligeiras),
    tem_sintoma(Doente, estavel_apesar_sintomas),
    not(tem_sintoma(Doente, falta_de_ar)),
    not(tem_sintoma(Doente, febre)),
    not(tem_sintoma(Doente, urticaria_espalha_grandes_areas)).

triagem_penicilina(Doente, autocuidados, 'Autocuidados com vigilancia apertada', 'Quadro clinico minimo. Requer interrupcao do farmaco e vigilancia.') :-
    tem_sintoma(Doente, pequenas_alteracoes_cutaneas_isoladas),
    not(tem_sintoma(Doente, manchas_ligeiras)),
    not(tem_sintoma(Doente, febre)).

% ========================================
% --- PROTOCOLO: ALERGIA A ANESTESICOS ---
% ========================================
triagem_anestesicos(Doente, emergencia, 'Acionar 112 (INEM) imediatamente', 'Sinais de anafilaxia ou toxicidade sistemica grave com risco de paragem cardiorrespiratoria.') :-
    (sintoma(Doente, dificuldade_respiratoria, V1), V1 >= 8) ;
    tem_sintoma(Doente, no_na_garganta) ;
    tem_sintoma(Doente, inchaco_rapido_labios) ;
    tem_sintoma(Doente, inchaco_rapido_lingua) ;
    tem_sintoma(Doente, palpitacoes) ;
    tem_sintoma(Doente, tremores) ;
    tem_sintoma(Doente, convulsoes) ;
    tem_sintoma(Doente, desorientado) ;
    tem_sintoma(Doente, desmaio).

triagem_anestesicos(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Reacao imunitaria moderada a grave que requer medicacao especifica.') :-
    not(tem_sintoma(Doente, no_na_garganta)),
    not(tem_sintoma(Doente, inchaco_rapido_labios)),
    not(tem_sintoma(Doente, inchaco_rapido_lingua)),
    not(tem_sintoma(Doente, palpitacoes)),
    not(tem_sintoma(Doente, tremores)),
    not(tem_sintoma(Doente, convulsoes)),
    not(tem_sintoma(Doente, desorientado)),
    not(tem_sintoma(Doente, desmaio)),
    not((sintoma(Doente, dificuldade_respiratoria, Vd), Vd >= 8)),
    (   (sintoma(Doente, dificuldade_respiratoria, V1), V1 >= 5, V1 < 8) ;
        tem_sintoma(Doente, urticaria_generalizada_horas_apos) ;
        tem_sintoma(Doente, inchaco_local_injeca) ;
        tem_sintoma(Doente, vomitos_repetidamente)
    ).

triagem_anestesicos(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Sintomas persistentes que requerem reavaliacao pelo profissional que realizou o procedimento.') :-
    not(tem_sintoma(Doente, vomitos_repetidamente)),
    not((sintoma(Doente, dificuldade_respiratoria, V2), V2 >= 5)),
    (   tem_sintoma(Doente, dormencia_mais_de_24_horas) ;
        tem_sintoma(Doente, vermelidao_local_persistente)
    ).

triagem_anestesicos(Doente, autocuidados, 'Autocuidados com vigilancia apertada', 'Efeito adverso ligeiro e localizado, sem sinais de compromisso sistemico.') :-
    not(tem_sintoma(Doente, dormencia_mais_de_24_horas)),
    not(tem_sintoma(Doente, vermelidao_local_persistente)),
    (   tem_sintoma(Doente, pequeno_inchaco_contido_no_local) ;
        tem_sintoma(Doente, dormencia_prolongada_sem_dor)
    ).

% =========================================================
% --- PROTOCOLO: ALERGIA OCULAR / CONJUNTIVITE ALERGICA ---
% =========================================================
triagem_ocular(Doente, emergencia, 'Acionar 112 (INEM) imediatamente', 'Dor extrema, perda de visao ou inchaco ocular com compromisso respiratorio.') :-
    (tem_sintoma(Doente, olhos_inchados_fechados) , tem_sintoma(Doente, falta_ar)) ;
    tem_sintoma(Doente, perda_subita_visao_turva) ;
    (sintoma(Doente, dor_ocular_profunda, V1), V1 >= 8).

triagem_ocular(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Presenca de pus ou dor moderada que sugere infeccao ou compromisso da cornea.') :-
    not(tem_sintoma(Doente, perda_subita_visao_turva)),
    not((tem_sintoma(Doente, olhos_inchados_fechados) , tem_sintoma(Doente, falta_ar))),
    not((sintoma(Doente, dor_ocular_profunda, Vd), Vd >= 8)),
    (   tem_sintoma(Doente, dor_luz_ohos) ;
        tem_sintoma(Doente, remela_espessa) ;
        tem_sintoma(Doente, olhos_inchados_fechados) ;
        (sintoma(Doente, dor_ocular_profunda, V2), V2 >= 5, V2 < 8)
    ).

triagem_ocular(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Sintomas persistentes que requerem ajuste terapeutico e observacao programada.') :-
    not(tem_sintoma(Doente, dor_luz_ohos)),
    not(tem_sintoma(Doente, remela_espessa)),
    not((sintoma(Doente, dor_ocular_profunda, V3), V3 >= 5)),
    tem_sintoma(Doente, comichao_vermelidao_48h).

triagem_ocular(Doente, autocuidados, 'Autocuidados com vigilancia apertada', 'Sintomas classicos e ligeiros, geriveis com higiene e medidas locais.') :-
    not(tem_sintoma(Doente, comichao_vermelidao_48h)),
    (   (sintoma(Doente, comichao_intensa_ambos_olhos, V4), V4 >= 0) ;
        tem_sintoma(Doente, sensacao_areia_olho) ;
        tem_sintoma(Doente, palpebras_inchadas)
    ).

% ====================================
% --- PROTOCOLO: ALERGIA ALIMENTAR ---
% ====================================
triagem_alimentar(Doente, emergencia, 'Acionar 112 (INEM) imediatamente', 'Indica falencia cardiovascular ou respiratoria aguda com risco de vida imediato.') :-
    tem_sintoma(Doente, dificuldade_respirar_chiadeira) ;
    tem_sintoma(Doente, pele_palida) ;
    tem_sintoma(Doente, coracao_bater_rapido) ;
    tem_sintoma(Doente, perda_de_consciencia).

triagem_alimentar(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'A envolvencia do sistema digestivo ou respiratorio inferior indica uma reacao moderada que pode progredir.') :-
    not(tem_sintoma(Doente, dificuldade_respirar_chiadeira)),
    not(tem_sintoma(Doente, pele_palida)),
    not(tem_sintoma(Doente, coracao_bater_rapido)),
    not(tem_sintoma(Doente, perda_de_consciencia)),
    (   tem_sintoma(Doente, colicas_fortes) ;
        tem_sintoma(Doente, vomitos_seguidos) ;
        tem_sintoma(Doente, diarreia_persistente) ;
        tem_sintoma(Doente, chiadeira_sem_falta_ar_grave)
    ).

triagem_alimentar(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Casos cronicos ou suspeitas de intolerancia que requerem estudo clinico programado.') :-
    not(tem_sintoma(Doente, colicas_fortes)),
    not(tem_sintoma(Doente, vomitos_seguidos)),
    not(tem_sintoma(Doente, chiadeira_sem_falta_ar_grave)),
    tem_sintoma(Doente, sintomas_apos_ingestao).

triagem_alimentar(Doente, autocuidados, 'Autocuidados com vigilancia apertada', 'Sintomas limitados a pele ou mucosas, sem compromisso de orgaos vitais.') :-
    not(tem_sintoma(Doente, sintomas_apos_ingestao)),
    (   tem_sintoma(Doente, marcas_leves_pele) ;
        tem_sintoma(Doente, comichao_labios_boca) ;
        tem_sintoma(Doente, comichao_garganta) ;
        tem_sintoma(Doente, espirros_apos_comer) ;
        tem_sintoma(Doente, lacrimejo_apos_comer)
    ).

% ================================
% --- PROTOCOLO: ALERGIA LATEX ---
% ================================
triagem_latex(Doente, emergencia, 'Acionar 112 (INEM)', 'Indica reacao anafilatica iminente por contacto com latex.') :-
    tem_sintoma(Doente, dificuldade_respirar) ;
    tem_sintoma(Doente, inchaco_lingua_garganta).

triagem_latex(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Reacao moderada com risco de progressao sistemica.') :-
    not(tem_sintoma(Doente, dificuldade_respirar)),
    not(tem_sintoma(Doente, inchaco_lingua_garganta)),
    (   tem_sintoma(Doente, urticaria_generalizada) ;
        (tem_sintoma(Doente, sintomas_asma) , tem_sintoma(Doente, sintomas_tosse_forte))
    ).

triagem_latex(Doente, nao_urgente, 'Marcacao de Consulta de Imunoalergologia', 'Sintomas persistentes ou ocupacionais que requerem investigacao.') :-
    not(tem_sintoma(Doente, urticaria_generalizada)),
    not((tem_sintoma(Doente, sintomas_asma) , tem_sintoma(Doente, sintomas_tosse_forte))),
    (   tem_sintoma(Doente, reacao_multiplos_locais) ;
        tem_sintoma(Doente, alertia_local_trabalho)
    ).

triagem_latex(Doente, autocuidados, 'Eviccao de produtos com latex e vigilancia', 'Reacao local controlada e limitada ao ponto de contacto.') :-
    not(tem_sintoma(Doente, reacao_multiplos_locais)),
    not(tem_sintoma(Doente, alertia_local_trabalho)),
    tem_sintoma(Doente, reacao_local_zona_latex).

% =================================================
% --- PROTOCOLO: ALERGIA A ANIMAIS DE ESTIMACAO ---
% =================================================
triagem_animais(Doente, emergencia, 'Acionar 112 (INEM) imediatamente', 'A exposicao pode desencadear uma crise de asma aguda ou anafilaxia.') :-
    tem_sintoma(Doente, dificuldade_em_respirar_ou_engolir) ;
    tem_sintoma(Doente, inchaco_garganta).

triagem_animais(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Sintomas respiratorios inferiores ou cutaneos extensos indicam uma reacao moderada.') :-
    not(tem_sintoma(Doente, dificuldade_em_respirar_ou_engolir)),
    not(tem_sintoma(Doente, inchaco_garganta)),
    (   tem_sintoma(Doente, chiado_apos_contacto_animal) ;
        tem_sintoma(Doente, urticaria_generalizada) ;
        tem_sintoma(Doente, inchaco_ocular_acentuado)
    ).

triagem_animais(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Sintomas cronicos que requerem um plano de dessensibilizacao ou controlo ambiental.') :-
    not(tem_sintoma(Doente, chiado_apos_contacto_animal)),
    not(tem_sintoma(Doente, urticaria_generalizada)),
    not(tem_sintoma(Doente, inchaco_ocular_acentuado)),
    (   (tem_sintoma(Doente, manchas_secas_asperas) , tem_sintoma(Doente, suspeita_exposicao_animais)) ;
        tem_sintoma(Doente, dor_facial)
    ).

triagem_animais(Doente, autocuidados, 'Autocuidados com vigilancia apertada', 'Reacao alergica ligeira, gerivel com medicacao de venda livre.') :-
    not(tem_sintoma(Doente, manchas_secas_asperas)),
    not(tem_sintoma(Doente, dor_facial)),
    (   tem_sintoma(Doente, espirros_frequentes) ;
        tem_sintoma(Doente, pingo_transparente) ;
        tem_sintoma(Doente, comichao_cara_garganta)
    ).

% ===============================================
% --- PROTOCOLO: ALERGIA A PICADAS DE INSETOS ---
% ===============================================
triagem_insetos(Doente, emergencia, 'Acionar 112 (INEM) imediatamente', 'Reacao anafilatica sistemica grave com risco de choque circulatorio ou paragem respiratoria.') :-
    tem_sintoma(Doente, urticaria_generalizada) ;
    tem_sintoma(Doente, inchaco_labios) ;
    tem_sintoma(Doente, inchaco_lingua) ;
    tem_sintoma(Doente, inchaco_garganta) ;
    tem_sintoma(Doente, dificuldade_em_respirar_ou_engolir) ;
    tem_sintoma(Doente, tonturas_ligeiras) ;
    tem_sintoma(Doente, palpiltacoes_fracas) ;
    tem_sintoma(Doente, colicas_intestinais).

triagem_insetos(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Risco de progressao para sintomas sistemicos ou necessidade de controlo da inflamacao severa.') :-
    not(tem_sintoma(Doente, urticaria_generalizada)),
    not(tem_sintoma(Doente, inchaco_labios)),
    not(tem_sintoma(Doente, inchaco_lingua)),
    not(tem_sintoma(Doente, inchaco_garganta)),
    not(tem_sintoma(Doente, dificuldade_em_respirar_ou_engolir)),
    not(tem_sintoma(Doente, tonturas_ligeiras)),
    not(tem_sintoma(Doente, palpiltacoes_fracas)),
    not(tem_sintoma(Doente, colicas_intestinais)),
    (   tem_sintoma(Doente, reacao_local) ; 
        tem_sintoma(Doente, multiplas_picadas_simultaneas) ;
        (sintoma(Doente, dor_aguda_local_picada, Vd), Vd >= 8)
    ).

triagem_insetos(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Necessidade de despiste de infecao secundária ou estudo imuno-alergológico.') :-
    not(tem_sintoma(Doente, reacao_local)),
    not(tem_sintoma(Doente, multiplas_picadas_simultaneas)),
    not((sintoma(Doente, dor_aguda_local_picada, Vp), Vp >= 8)),
    (   tem_sintoma(Doente, picada_piorou_24h) ;
        tem_sintoma(Doente, picada_pus) ;
        tem_sintoma(Doente, picada_quente) ;
        tem_sintoma(Doente, reacoes_passadas)
    ).

triagem_insetos(Doente, autocuidados, 'Autocuidados com vigilancia apertada', 'Reacao inflamatoria local controlada, gerivel com medidas fisicas e higiene.') :-
    not(tem_sintoma(Doente, picada_piorou_24h)),
    not(tem_sintoma(Doente, picada_pus)),
    (   (sintoma(Doente, dor_aguda_local_picada, V1), V1 =< 4) ;
        tem_sintoma(Doente, inchaco_local_picada) ;
        tem_sintoma(Doente, comichao_local_picada)
    ).

% =========================================
% --- PROTOCOLO: URTICARIA E ANGIOEDEMA ---
% =========================================
triagem_urticaria(Doente, emergencia, 'Acionar 112 (INEM) imediatamente', 'Indica que o angioedema esta a bloquear as vias aereas ou a evoluir para anafilaxia.') :-
    tem_sintoma(Doente, inchaco_lingua_garganta) ;
    tem_sintoma(Doente, voz_abafada) ;
    tem_sintoma(Doente, dificuldade_engolir_saliva) ;
    tem_sintoma(Doente, desmaio_recente).

triagem_urticaria(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Reacao sistemica agressiva que requer intervencao medica para controlar a inflamacao.') :-
    not(tem_sintoma(Doente, inchaco_lingua_garganta)),
    not(tem_sintoma(Doente, voz_abafada)),
    not(tem_sintoma(Doente, dificuldade_engolir_saliva)),
    not(tem_sintoma(Doente, desmaio_recente)),
    (   tem_sintoma(Doente, vermelhidao_mais_metade_corpo) ;
        tem_sintoma(Doente, inchaco_facial) ;
        tem_sintoma(Doente, manchas_dor_abdominal) ;
        tem_sintoma(Doente, manchas_febre)
    ).

triagem_urticaria(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Necessidade de diagnostico especializado para identificar causas fisicas ou cronicas.') :-
    not(tem_sintoma(Doente, vermelhidao_mais_metade_corpo)),
    not(tem_sintoma(Doente, inchaco_facial)),
    not(tem_sintoma(Doente, manchas_dor_abdominal)),
    not(tem_sintoma(Doente, manchas_febre)),
    (   tem_sintoma(Doente, reacoes_ao_sol) ;
        tem_sintoma(Doente, pele_empolada)
    ).

triagem_urticaria(Doente, autocuidados, 'Autocuidados com vigilancia apertada', 'Quadro clinico estavel e localizado onde a remocao do gatilho e suficiente.') :-
    not(tem_sintoma(Doente, reacoes_ao_sol)),
    not(tem_sintoma(Doente, pele_empolada)),
    (   tem_sintoma(Doente, pequenas_manchas_menos_24h) ;
        tem_sintoma(Doente, ligeiro_inchaco_isolado) ;
        tem_sintoma(Doente, labio_inchado) ;
        tem_sintoma(Doente, pele_ligeiramente_vermelha)
    ).

% =============================
% --- PROTOCOLO: ANAFILAXIA ---
% =============================
triagem_anafilaxia(Doente, emergencia, 'Acionar 112 ou ida imediata a Urgencia', 'Indica falencia respiratoria ou choque anafilatico iminente. O tempo de resposta e medido em segundos.') :-
    tem_sintoma(Doente, sufoco_iminente) ;
    tem_sintoma(Doente, lingua_bloqueia_passagem_ar) ;
    tem_sintoma(Doente, voz_rouca_subita) ;
    tem_sintoma(Doente, pele_ligeiramente_azul).

triagem_anafilaxia(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Reacao sistemica progressiva que afeta mais do que um orgao, com risco elevado de evoluir para choque.') :-
    not(tem_sintoma(Doente, sufoco_iminente)),
    not(tem_sintoma(Doente, lingua_bloqueia_passagem_ar)),
    not(tem_sintoma(Doente, voz_rouca_subita)),
    not(tem_sintoma(Doente, pele_ligeiramente_azul)),
    (   tem_sintoma(Doente, vomitos_repetidos) ;
        tem_sintoma(Doente, peito_esmagado) ;
        tem_sintoma(Doente, coracao_descontrolado) ;
        tem_sintoma(Doente, comichao_palmas_maos) ;
        tem_sintoma(Doente, comichao_palmas_pes) ;
        tem_sintoma(Doente, formigueiro_labios) ;
        tem_sintoma(Doente, ansiedade_pos_contacto)
    ).

triagem_anafilaxia(Doente, autocuidados, 'Educacao e Autocuidados', 'Foco na prevencao secundaria e na prontidao para agir perante novos contactos.') :-
    not(tem_sintoma(Doente, vomitos_repetidos)),
    not(tem_sintoma(Doente, peito_esmagado)),
    not(tem_sintoma(Doente, ansiedade_pos_contacto)),
    tem_sintoma(Doente, historico_anafilaxia).

% ==================================================
% --- PROTOCOLO: ANGIOEDEMA (INCHACO SUBCUTANEO) ---
% ==================================================
triagem_angioedema(Doente, emergencia, 'Acionar 112 ou ida imediata a Urgencia', 'Indica risco iminente de asfixia ou edema grave de orgaos internos.') :-
    tem_sintoma(Doente, inchaco_lingua_garganta) ;
    tem_sintoma(Doente, voz_abafada) ;
    tem_sintoma(Doente, dificuldade_engolir_saliva) ;
    (sintoma(Doente, inchaco_palpebras, V1), V1 >= 8) ;
    (sintoma(Doente, inchaco_labios, V2), V2 >= 8) ;
    (sintoma(Doente, inchaco_maos, V3), V3 >= 8) ;
    (sintoma(Doente, colicas, V4), V4 >= 8).

triagem_angioedema(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'O edema e moderado mas requer intervencao para evitar progressao para as vias aereas.') :-
    not(tem_sintoma(Doente, inchaco_lingua_garganta)),
    not(tem_sintoma(Doente, voz_abafada)),
    not(tem_sintoma(Doente, dificuldade_engolir_saliva)),
    not((sintoma(Doente, colicas, Vc), Vc >= 8)),
    (   (sintoma(Doente, inchaco_palpebras, V5), V5 >= 5, V5 < 8) ; 
        (sintoma(Doente, inchaco_labios, V6), V6 >= 5, V6 < 8) ;    
        (sintoma(Doente, inchaco_maos, V7), V7 >= 5, V7 < 8) ;     
        (sintoma(Doente, colicas, V8), V8 >= 5, V8 < 8)            
    ).

triagem_angioedema(Doente, nao_urgente, 'Contacto com Medico Assistente ou Linha Saude 24', 'Reacao ligeira que requer investigacao para evitar agravamento futuro.') :-
    not((sintoma(Doente, inchaco_palpebras, Vp), Vp >= 5)),
    not((sintoma(Doente, colicas, Vco), Vco >= 5)),
    (   (sintoma(Doente, formigueiro, V9), V9 >= 5) ;
        tem_sintoma(Doente, inchaco_rosto)
    ).

triagem_angioedema(Doente, autocuidados, 'Educacao e Autocuidados', 'Foco na prevencao primaria e identificacao de gatilhos.') :-
    not(tem_sintoma(Doente, inchaco_rosto)),
    not((sintoma(Doente, formigueiro, Vf), Vf >= 5)),
    tem_sintoma(Doente, historico_angioedema_sem_sintomas_ativos).

% =================================================================
% --- PROTOCOLO: DERMATITE (ATOPICA, DE CONTACTO OU SEBORREICA) ---
% =================================================================
triagem_dermatite(Doente, emergencia, 'Acionar 112 ou ida imediata a Urgencia', 'Indica risco de falencia sistemica ou sepsis por perda da barreira cutanea.') :-
    tem_sintoma(Doente, febre_alta_provocada_erupcao) ;
    tem_sintoma(Doente, bolhas_grande_parte_corpo) ;
    tem_sintoma(Doente, prostracao_e_calafrios) ;
    (sintoma(Doente, comichao, V1), V1 >= 8).

triagem_dermatite(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Sinais de infeccao secundaria que requerem antibioticos para evitar celulite.') :-
    not(tem_sintoma(Doente, febre_alta_provocada_erupcao)),
    not(tem_sintoma(Doente, bolhas_grande_parte_corpo)),
    not(tem_sintoma(Doente, prostracao_e_calafrios)),
    (   tem_sintoma(Doente, sinais_de_infeccao_pus) ;
        tem_sintoma(Doente, sinais_de_infeccao_crostas) ;
        tem_sintoma(Doente, sinais_de_infeccao_calor) ;
        tem_sintoma(Doente, sinais_de_infeccao_dolorosa) ;
        (sintoma(Doente, comichao, V2), V2 >= 5, V2 < 8) 
    ).

triagem_dermatite(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Necessidade de ajuste da terapeutica de base e avaliacao da barreira cutanea.') :-
    not(tem_sintoma(Doente, sinais_de_infeccao_pus)),
    not(tem_sintoma(Doente, sinais_de_infeccao_calor)),
    not((sintoma(Doente, comichao, V3), V3 >= 5)),
    (   tem_sintoma(Doente, feridas_nao_melhoram_com_cremes) ;
        tem_sintoma(Doente, vermelhidao_persistente_nas_dobras) ;
        tem_sintoma(Doente, pele_muito_seca)
    ).

triagem_dermatite(Doente, autocuidados, 'Autocuidados em casa', 'Gestao cronica da barreira cutanea para evitar surtos; foco no conforto.') :-
    not(tem_sintoma(Doente, feridas_nao_melhoram_com_cremes)),
    (   tem_sintoma(Doente, pele_descamae_fininho) ;
        tem_sintoma(Doente, pele_comichao) 
    ).

% =============================================================
% --- PROTOCOLO: ASPERGILOSE BRONCOPULMONAR ALERGICA (ABPA) ---
% =============================================================
triagem_abpa(Doente, emergencia, 'Acionar 112 ou ida imediata a Urgencia', 'Indica complicacoes agudas como pneumotorax ou risco de paragem respiratoria.') :-
    tem_sintoma(Doente, falta_de_ar_em_repouso) ;
    tem_sintoma(Doente, cianose_labios_unhas) ;
    tem_sintoma(Doente, dor_toracica) ;
    tem_sintoma(Doente, tosse_sangue) ;
    (sintoma(Doente, peito_pesado_ambientes_humidos, V1), V1 >= 8).

triagem_abpa(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Presenca de muco castanho ou febre sugere inflamacao que requer ajuste terapeutico.') :-
    not(tem_sintoma(Doente, falta_de_ar_em_repouso)),
    not(tem_sintoma(Doente, tosse_sangue)),
    not((sintoma(Doente, peito_pesado_ambientes_humidos, Vd), Vd >= 8)),
    (   tem_sintoma(Doente, febre_persistente) ;
        tem_sintoma(Doente, muco_castanho) ;
        tem_sintoma(Doente, cansaco_extremo) ;
        tem_sintoma(Doente, pieira_inalador) ;
        (sintoma(Doente, peito_pesado_ambientes_humidos, V2), V2 >= 5, V2 < 8) 
    ).

triagem_abpa(Doente, nao_urgente, 'Marcacao de Consulta no Centro de Saude', 'Sintomas subagudos que indicam falta de controlo ambiental ou progressao lenta.') :-
    not(tem_sintoma(Doente, muco_castanho)),
    not(tem_sintoma(Doente, febre_persistente)),
    not((sintoma(Doente, peito_pesado_ambientes_humidos, V3), V3 >= 5)),
    (   (tem_sintoma(Doente, tosse_persistente) , tem_sintoma(Doente, aumento_expetoracao)) ;
        (sintoma(Doente, peito_pesado_ambientes_humidos, V4), V4 > 0, V4 < 5)
    ).

triagem_abpa(Doente, autocuidados, 'Autocuidados e Manutencao', 'Foco na prevencao da reexposicao aos esporos para evitar novas crises.') :-
    not(tem_sintoma(Doente, tosse_persistente)),
    not(tem_sintoma(Doente, aumento_expetoracao)),
    (   tem_sintoma(Doente, estavel_apesar_sintomas) ;
        tem_sintoma(Doente, exposicao_pos_organicos)
    ).

% =======================================================
% --- PROTOCOLO: ALERGIA A ANTI-INFLAMATORIOS (AINES) ---
% =======================================================
triagem_aines(Doente, emergencia, 'Acionar 112 (INEM) imediatamente', 'Indica broncoespasmo severo ou choque anafilatico. A reacao respiratoria e fulminante.') :-
    tem_sintoma(Doente, dificuldade_subita_respirar) ;
    tem_sintoma(Doente, dificuldade_subita_pieira) ;
    tem_sintoma(Doente, dificuldade_subita_aperto_peito) ;
    tem_sintoma(Doente, inchaco_lingua) ;
    tem_sintoma(Doente, inchaco_garganta) ;
    tem_sintoma(Doente, perda_consciencia) ;
    tem_sintoma(Doente, palidez_extrema).

triagem_aines(Doente, urgente, 'Servico de Urgencia ou Centro de Saude em 24h', 'Reacao sistemica moderada com risco de progressao rapida para compromisso respiratorio ou circulatorio.') :-
    not(tem_sintoma(Doente, dificuldade_subita_respirar)),
    not(tem_sintoma(Doente, inchaco_lingua)),
    not(tem_sintoma(Doente, inchaco_garganta)),
    not(tem_sintoma(Doente, perda_consciencia)),
    not(tem_sintoma(Doente, palidez_extrema)),
    (   tem_sintoma(Doente, angioedema_palpebras) ;
        tem_sintoma(Doente, angioedema_labios) ;
        tem_sintoma(Doente, urticaria_espalha_continuamente) ;
        tem_sintoma(Doente, dor_abdominal_forte_vomitos_apos_toma)
    ).

triagem_aines(Doente, nao_urgente, 'Contacto com Medico Assistente / Imunoalergologia', 'Reacao ligeira/tardia que requer investigacao diagnostica para evitar reexposicoes perigosas.') :-
    not(tem_sintoma(Doente, urticaria_espalha_continuamente)),
    not(tem_sintoma(Doente, dor_abdominal_forte_vomitos_apos_toma)),
    not(tem_sintoma(Doente, angioedema_palpebras)),
    tem_sintoma(Doente, comichao_ligeira_tardio_apos_tomar_farmaco).

triagem_aines(Doente, autocuidados, 'Foco na prevencao primaria e eviccao.', 'Doente estavel, necessita apenas de suspensao do farmaco e vigilancia.') :-
    not(tem_sintoma(Doente, comichao_ligeira_tardio_apos_tomar_farmaco)),
    not(tem_sintoma(Doente, angioedema_labios)),
    tem_sintoma(Doente, estavel_apesar_sintomas).