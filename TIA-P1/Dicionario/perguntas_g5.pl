:- encoding(utf8).

:- multifile pergunta_sn/2.
:- multifile pergunta_escala/2.

% ===================================================
% --- G5: RINOSSINUSITE ---
% ===================================================
pergunta_sn(alteracao_da_visao, 'O doente apresenta alteracao da visao (ex: visao dupla, manchas ou visao turva)?').
pergunta_escala(inchaco_nos_olhos, 'Qual a severidade do inchaco ou vermelhidao ao redor dos olhos?').
pergunta_escala(rigidez_no_pescoco, 'Qual e a dificuldade/dor que sente ao tentar encostar o queixo ao peito (rigidez)?').
pergunta_escala(dor_facial, 'Qual a intensidade da dor de cabeca ou pressao forte na face?').
pergunta_sn(febre_alta, 'O doente apresenta febre alta de inicio subito?').
pergunta_escala(corrimento_purulento, 'Qual a abundancia do corrimento nasal espesso, amarelado ou esverdeado?').
pergunta_sn(sintomas_congestao, 'O nariz entupido e as dores de cabeca ja duram de forma continua ha mais de uma semana?').
pergunta_sn(peso_na_face, 'O doente sente peso ou uma pressao incomoda na zona das macas do rosto?').
pergunta_sn(corrimento_claro, 'O corrimento nasal e totalmente claro/transparente e comecou ha poucos dias?').

% ===================================================
% --- G5: RINITE ALERGICA ---
% ===================================================
pergunta_escala(dificuldade_respiratoria, 'Qual a intensidade global da dificuldade em respirar?').
pergunta_sn(inchaco_visivel_na_garganta, 'Existe um inchaco visivel no interior ou exterior da garganta?').
pergunta_escala(febre, 'Qual a intensidade da febre neste momento?').
pergunta_sn(sintomas_impedem_sono, 'Os sintomas (como congestao nasal) sao tao fortes que chegam a impedir o sono noturno?').
pergunta_escala(tosse_noturna, 'Qual a severidade da tosse noturna provocada pelas secrecoes nasais?').
pergunta_sn(sangramento_nasal_frequente, 'Tem tido sangramentos nasais recentes ou muito frequentes por irritacao do nariz?').
pergunta_escala(comichao_nariz, 'Qual o nivel de comichao (prurido) constante no nariz?').
pergunta_escala(comichao_olhos, 'Qual o nivel de comichao (prurido) que sente nos olhos?').
pergunta_sn(corrimento_nasal, 'Tem corrimento nasal liquido e muito transparente (pingo constante)?').

% ===================================================
% --- G5: OCULAR (Conjuntivite Alergica) ---
% ===================================================
pergunta_sn(olhos_inchados_fechados, 'O inchaco e tao severo que os olhos encontram-se fechados?').
pergunta_sn(falta_ar, 'Juntamente com os sintomas oculares sente tambem falta de ar?').
pergunta_sn(perda_subita_visao_turva, 'O doente perdeu subitamente a visao ou esta a ver tudo muito turvo e escuro?').
pergunta_escala(dor_ocular_profunda, 'Qual a intensidade da dor forte e profunda sentida no interior do olho?').
pergunta_sn(dor_luz_ohos, 'A luz natural ou artificial faz muita dor nos olhos (fotofobia)?').
pergunta_sn(remela_espessa, 'Os olhos deitam muito pus amarelado ou remela que cola as palpebras de manha?').
pergunta_sn(comichao_vermelidao_48h, 'Os olhos estao vermelhos, inflamados e com comichao continua ha mais de 48 horas?').
pergunta_escala(comichao_intensa_ambos_olhos, 'Qual a intensidade da comichao (vontade de esfregar) em ambos os olhos?').
pergunta_sn(sensacao_areia_olho, 'Sente com frequencia uma sensacao de picadas ou areias dentro do olho?').
pergunta_sn(palpebras_inchadas, 'As palpebras estao ligeiramente pesadas ou inchadas devido a alergia?').