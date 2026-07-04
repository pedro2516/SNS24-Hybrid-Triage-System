:- encoding(utf8).

:- multifile pergunta_sn/2.
:- multifile pergunta_escala/2.

% ===================================================
% --- G3: PENICILINA E ANTIBIOTICOS ---
% ===================================================
pergunta_sn(dificuldade_subita_respirar, 'Sentiu subitamente falta de ar apos a toma?').
pergunta_sn(dificuldade_subita_pieira, 'Comecou subitamente a ouvir-se um chiar no peito?').
pergunta_sn(dificuldade_subita_aperto_peito, 'Sentiu subitamente um aperto forte no peito?').
pergunta_sn(inchaco_rapido_labios, 'Os labios incharam rapidamente numa questao de minutos?').
pergunta_sn(inchaco_rapido_lingua, 'A lingua inchou rapidamente numa questao de minutos?').
pergunta_sn(tonturas_extremas_ou_desmaio, 'Sentiu tonturas extremas ou chegou mesmo a desmaiar?').
pergunta_sn(urticaria_generalizada_subita, 'Apareceram subitamente manchas empoladas pelo corpo todo?').
pergunta_escala(falta_de_ar, 'Qual a intensidade geral da falta de ar atual?').
pergunta_sn(urticaria_espalha_grandes_areas, 'A urticaria esta a alastrar de forma agressiva para areas maiores?').
pergunta_sn(manchas_ligeiras, 'Apresenta apenas manchas vermelhas ligeiras na pele?').
pergunta_escala(dor_inchaco_articulacoes, 'Qual a intensidade da dor provocada por inchacos nas articulacoes?').
pergunta_escala(prurido_ligeiro_sem_manchas_ou_febre, 'Qual a intensidade da comichao (sem outros sinais visiveis)?').
pergunta_sn(pequenas_alteracoes_cutaneas_isoladas, 'Apresenta apenas alteracoes cutaneas muito pequenas e limitadas?').

% ===================================================
% --- G3: AINES (Anti-inflamatorios) ---
% ===================================================
pergunta_sn(perda_consciencia, 'O doente perdeu a consciencia ou sentiu que ia desmaiar?').
pergunta_sn(palidez_extrema, 'A pele ficou com uma palidez extrema (branca/cinzenta)?').
pergunta_sn(angioedema_palpebras, 'Os olhos ou as palpebras incharam rapidamente apos a toma?').
pergunta_sn(angioedema_labios, 'Os labios incharam muito rapidamente apos tomar o medicamento?').
pergunta_sn(urticaria_espalha_continuamente, 'A urticaria/manchas estao ativamente a espalhar-se pelo corpo?').
pergunta_sn(dor_abdominal_forte_vomitos_apos_toma, 'Teve vomitos intensos ou dores de barriga fortes logo apos tomar o comprimido?').
pergunta_sn(comichao_ligeira_tardio_apos_tomar_farmaco, 'Surgiu apenas uma comichao ou vermelhidao ligeira, muitas horas apos a toma?').

% ===================================================
% --- G3: ANESTESICOS ---
% ===================================================
pergunta_sn(no_na_garganta, 'Sente como se tivesse um "no" apertado na garganta a fechar a respiracao?').
pergunta_sn(palpitacoes, 'O doente sente o coracao a bater muito depressa de forma anormal?').
pergunta_sn(tremores, 'O doente tem tremores fortes incontrolaveis?').
pergunta_sn(convulsoes, 'O doente teve convulsoes ou espasmos musculares?').
pergunta_sn(desmaio, 'O doente desmaiou durante ou logo apos o procedimento?').
pergunta_sn(urticaria_generalizada_horas_apos, 'Apareceram manchas tipo picada pelo corpo algumas horas apos a anestesia?').
pergunta_sn(inchaco_local_injeca, 'O local onde levou a injecao (agulha) esta a inchar muito?').
pergunta_sn(vomitos_repetidamente, 'O doente vomitou repetidas vezes apos o procedimento?').
pergunta_sn(dormencia_mais_de_24_horas, 'A dormencia da anestesia local ainda persiste apos 24 horas?').
pergunta_sn(vermelidao_local_persistente, 'O local da picada mantem-se vermelho ou quente ha varios dias?').
pergunta_sn(pequeno_inchaco_contido_no_local, 'Existe apenas um pequeno inchaço inofensivo no exato sitio onde levou a anestesia?').
pergunta_sn(dormencia_prolongada_sem_dor, 'O local ainda esta adormecido, mas sem qualquer dor associada?').