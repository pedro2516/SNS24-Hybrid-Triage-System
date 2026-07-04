:- encoding(utf8).

:- multifile pergunta_sn/2.
:- multifile pergunta_escala/2.

% ===================================================
% --- G4: DERMATITE ---
% ===================================================
pergunta_sn(febre_alta_provocada_erupcao, 'Tem febre muito alta associada a uma erupcao vermelha que alastra rapidamente?').
pergunta_sn(bolhas_grande_parte_corpo, 'Tem bolhas de agua dolorosas que cobrem grande parte do corpo?').
pergunta_sn(prostracao_e_calafrios, 'O doente encontra-se prostrado (sem reagir) ou com fortes calafrios?').
pergunta_sn(sinais_de_infeccao_pus, 'As feridas ou a pele afetada tem pus visivel?').
pergunta_sn(sinais_de_infeccao_crostas, 'A pele desenvolveu crostas amareladas e humidas?').
pergunta_sn(sinais_de_infeccao_calor, 'A area afetada da pele esta muito quente ao toque?').
pergunta_sn(sinais_de_infeccao_dolorosa, 'A area afetada esta invulgarmente dolorosa?').
pergunta_escala(comichao, 'Qual a intensidade da comichao no corpo?').
pergunta_escala(comichao_corpo, 'Qual a intensidade da comichao espalhada pelo corpo todo?').
pergunta_escala(comichao_noturna, 'Qual a intensidade da comichao que sente durante a noite?').
pergunta_escala(pele_aspera_dobras, 'Qual o nivel de rugosidade ou aspreza da pele nas dobras?').
pergunta_escala(fadiga_constante, 'Qual a intensidade da fadiga constante que tem sentido?').
pergunta_sn(feridas_nao_melhoram_com_cremes, 'As lesoes na pele nao estao a melhorar, mesmo com os cremes habituais?').
pergunta_sn(vermelhidao_persistente_nas_dobras, 'A vermelhidao nas dobras dos bracos/pernas mantem-se de forma persistente?').
pergunta_sn(pele_muito_seca, 'A pele do corpo esta globalmente muito seca e aspera?').
pergunta_sn(pele_descamae_fininho, 'Tem a pele do corpo a descamar fininho, sem apresentar grandes feridas inflamadas?').
pergunta_sn(pele_comichao, 'A pele provoca comichao frequente mas gerivel?').

% ===================================================
% --- G4: URTICARIA E ANGIOEDEMA ---
% ===================================================
pergunta_sn(inchaco_lingua_garganta, 'A lingua ou a garganta estao a inchar?').
pergunta_sn(voz_abafada, 'A voz do doente soa abafada ou diferente do habitual?').
pergunta_sn(dificuldade_engolir_saliva, 'Tem dificuldade ou dor a engolir a propria saliva?').
pergunta_sn(desmaio_recente, 'Houve algum desmaio recentemente?').
pergunta_sn(vermelhidao_mais_metade_corpo, 'As manchas vermelhas ou empoladas cobrem mais de metade do corpo do doente?').
pergunta_sn(inchaco_facial, 'O inchaco na face e tao forte que altera as feicoes do rosto?').
pergunta_sn(manchas_dor_abdominal, 'Alem das manchas na pele, o doente tem fortes dores abdominais?').
pergunta_sn(manchas_febre, 'Alem das manchas, o doente tem febre?').
pergunta_sn(reacoes_ao_sol, 'As manchas surgiram predominantemente nas zonas que estiveram expostas ao sol?').
pergunta_sn(pele_empolada, 'A pele fica rapidamente marcada e empolada so de passar o dedo ou com a pressao da roupa?').
pergunta_sn(pequenas_manchas_menos_24h, 'Surgiram pequenas manchas altas que tendem a desaparecer/mudar de sitio em menos de 24 horas?').
pergunta_sn(ligeiro_inchaco_isolado, 'Apresenta apenas um ligeiro inchaco perfeitamente isolado (ex: num so dedo ou na mao)?').
pergunta_sn(labio_inchado, 'Apenas uma pequena parte do labio esta inchada, sem dificuldade em respirar?').
pergunta_sn(pele_ligeiramente_vermelha, 'A pele fica ligeiramente vermelha ao cocar, mas sem dar grandes problemas?').
pergunta_escala(inchaco_palpebras, 'Qual o nivel ou intensidade do inchaco visivel nas palpebras?').
pergunta_escala(inchaco_labios, 'Qual o nivel ou intensidade do inchaco visivel nos labios?').
pergunta_escala(inchaco_maos, 'Qual o nivel de inchaco sentido ou visivel nas maos/pes?').
pergunta_escala(colicas, 'Qual a intensidade da dor provocada por colicas intestinais?').
pergunta_escala(formigueiro, 'Qual a intensidade do formigueiro que esta a sentir no corpo?').
pergunta_sn(inchaco_rosto, 'Tem um ligeiro inchaco na zona do rosto ou contorno dos olhos?').
pergunta_sn(historico_angioedema_sem_sintomas_ativos, 'Tem historial medico de angioedema (inchacos), mas neste momento nao apresenta sintomas ativos?').