:- encoding(utf8).

:- multifile pergunta_sn/2.
:- multifile pergunta_escala/2.

% ======================================
% --- Nivel 1: Categorias principais ---
% ======================================
pergunta_sn(queixas_respiratorias, 'O problema principal afeta a respiracao (ex: falta de ar, tosse)?').
pergunta_sn(queixas_na_pele, 'O problema principal afeta a pele (ex: manchas, comichao, feridas)?').
pergunta_sn(queixas_medicamentosas, 'O motivo da chamada esta relacionado com a toma recente de um medicamento ou exame?').
pergunta_sn(queixas_oculares, 'O problema principal afeta os olhos (ex: comichao, visao turva, inchaco)?').
pergunta_sn(queixas_alimentares, 'Os sintomas surgiram apos a ingestao de algum alimento suspeito?').
pergunta_sn(suspeita_exposicao_latex, 'Esteve recentemente em contacto com produtos de latex ou borracha natural?').
pergunta_sn(suspeita_exposicao_animais, 'Esteve em contacto com animais de estimacao (ex: caes, gatos)?').
pergunta_sn(queixas_picadas_insetos, 'Foi picado recentemente por algum inseto (ex: abelha, vespa)?').
pergunta_sn(suspeita_anafilaxia, 'O doente apresenta um quadro de reacao alergica generalizada e subita no corpo todo?').
pergunta_sn(suspeita_angioedema, 'O doente apresenta inchacos muito acentuados e profundos na pele, palpebras ou labios?').

% ==============================================================
% --- Nivel 2: Sub-funis (despiste dentro de cada categoria) ---
% ==============================================================

% Respiratorio
pergunta_sn(historico_asma, 'O doente tem historico de asma?').
pergunta_sn(falta_de_ar_com_pieira, 'O doente apresenta falta de ar com "pieira" (chiadeira no peito)?').
pergunta_sn(dor_na_face, 'O doente tem dor forte na face ou nos seios perinasais?').
pergunta_sn(nariz_entupido, 'O doente tem o nariz muito entupido?').
pergunta_sn(corrimento_amarelo, 'O doente apresenta corrimento nasal amarelo ou esverdeado?').
pergunta_sn(espirros_frequentes, 'O doente tem espirros muito frequentes?').
pergunta_sn(comichao_no_nariz, 'O doente tem muita comichao no nariz?').
pergunta_sn(tosse, 'O doente tem tosse?').
pergunta_sn(muco_castanho, 'O doente tem tido muco de cor castanha?').

% Pele
pergunta_sn(manchas_com_muita_comichao, 'A pele tem manchas altas tipo picada que dao muita comichao?').
pergunta_sn(pele_cronicamente_seca, 'O doente tem a pele cronicamente muito seca (historial de dermatite)?').
pergunta_sn(pele_com_descamacao, 'O doente tem zonas da pele com descamacao (a esfolar fininho)?').

% Medicamentos e Procedimentos
pergunta_sn(tomou_penicilina, 'O medicamento que tomou era um antibiotico do tipo Penicilina (ou derivado)?').
pergunta_sn(tomou_anti_inflamatorio, 'Tomou algum anti-inflamatorio nao esteroide (ex: Ibuprofeno, Aspirina, Brufen)?').
pergunta_sn(anestesia_recentemente, 'O doente foi sujeito a alguma anestesia local ou geral recentemente?').