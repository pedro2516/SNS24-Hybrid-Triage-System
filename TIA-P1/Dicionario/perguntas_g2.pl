:- encoding(utf8).

:- multifile pergunta_sn/2.
:- multifile pergunta_escala/2.

% ===================================================
% --- G2: ANAFILAXIA (Emergencia Maxima) ---
% ===================================================
pergunta_sn(sufoco_iminente, 'O doente sente um sufoco iminente (sensacao de asfixia)?').
pergunta_sn(lingua_bloqueia_passagem_ar, 'A lingua esta tao inchada que bloqueia a passagem de ar?').
pergunta_sn(voz_rouca_subita, 'Ficou com a voz rouca subitamente apos um contacto?').
pergunta_sn(pele_ligeiramente_azul, 'A pele apresenta um tom ligeiramente azulado ou acinzentado?').
pergunta_sn(vomitos_repetidos, 'O doente tem vomitado repetidas vezes de forma incontrolavel?').
pergunta_sn(peito_esmagado, 'Sente o peito "esmagado" ou com muita pressao?').
pergunta_sn(coracao_descontrolado, 'Sente o coracao a bater de forma muito acelerada e descontrolada?').
pergunta_sn(comichao_palmas_maos, 'Sente uma comichao subita e intensa nas palmas das maos?').
pergunta_sn(comichao_palmas_pes, 'Sente comichao intensa nas plantas dos pes?').
pergunta_sn(formigueiro_labios, 'Sente formigueiro nos labios ou na boca?').
pergunta_sn(ansiedade_pos_contacto, 'Sentiu uma ansiedade/panico muito forte logo apos o possivel contacto alergico?').
pergunta_sn(historico_anafilaxia, 'O doente tem historico clinico de episodios de anafilaxia no passado?').

% ===================================================
% --- G2: ALERGIA ALIMENTAR ---
% ===================================================
pergunta_sn(dificuldade_respirar_chiadeira, 'Sente dificuldade em respirar ou o peito a chiar?').
pergunta_sn(pele_palida, 'A pele ficou subitamente muito palida?').
pergunta_sn(coracao_bater_rapido, 'Sente o coracao a bater muito rapido?').
pergunta_sn(perda_de_consciencia, 'O doente desmaiou ou perdeu os sentidos?').
pergunta_sn(colicas_fortes, 'Tem colicas intestinais muito fortes?').
pergunta_sn(vomitos_seguidos, 'Tem vomitos seguidos e intensos?').
pergunta_sn(diarreia_persistente, 'Tem diarreia que nao para?').
pergunta_sn(chiadeira_sem_falta_ar_grave, 'Tem o peito a chiar, mas ainda consegue respirar sem grande esforco?').
pergunta_sn(sintomas_apos_ingestao, 'Costuma ter sintomas ligeiros (desconforto) sempre que come este alimento?').
pergunta_sn(marcas_leves_pele, 'Surgiram apenas algumas marcas leves na pele ao redor da boca?').
pergunta_sn(comichao_labios_boca, 'Sente formigueiro ou comichao nos labios ou ceu da boca?').
pergunta_sn(espirros_apos_comer, 'Teve crises de espirros logo apos comer?').
pergunta_sn(lacrimejo_apos_comer, 'Ficou com os olhos a chorar ou nariz a pingar apos comer?').

% ===================================================
% --- G2: INSETOS ---
% ===================================================
pergunta_sn(urticaria_generalizada, 'Apareceram marcas vermelhas (urticaria) espalhadas por todo o corpo?').
pergunta_sn(inchaco_labios, 'A picada fez inchar os labios de forma severa?').
pergunta_sn(inchaco_lingua, 'A picada fez inchar a lingua?').
pergunta_sn(tonturas_ligeiras, 'Sente tonturas ligeiras e fraqueza?').
pergunta_sn(palpiltacoes_fracas, 'Sente o coracao a bater fraco ou de forma estranha?').
pergunta_sn(colicas_intestinais, 'Comecou com colicas intestinais subitas apos a picada?').
pergunta_sn(reacao_local, 'O inchaco no local da picada e gigante e esta a espalhar-se por todo o membro?').
pergunta_sn(multiplas_picadas_simultaneas, 'O doente foi atacado e sofreu varias picadas de insetos ao mesmo tempo?').
pergunta_sn(picada_piorou_24h, 'O local da picada piorou, avermelhou ou inchou ainda mais apos 24 horas?').
pergunta_sn(picada_pus, 'A picada esta a deitar pus?').
pergunta_sn(picada_quente, 'O local da picada esta invulgarmente quente ao toque?').
pergunta_sn(reacoes_passadas, 'O doente teve reacoes invulgares ou graves a picadas no passado?').
pergunta_escala(dor_aguda_local_picada, 'Qual a intensidade da dor no local exato onde foi picado?').
pergunta_sn(inchaco_local_picada, 'O inchaco na area em redor da picada e perfeitamente local e contido?').
pergunta_sn(comichao_local_picada, 'A comichao mantem-se forte, mas apenas na area da picada?').

% ===================================================
% --- G2: LATEX ---
% ===================================================
pergunta_sn(dificuldade_respirar, 'O doente tem dificuldade obvia em respirar?').
pergunta_sn(sintomas_asma, 'Desenvolveu subitamente sintomas de asma (falta de ar/aperto no peito)?').
pergunta_sn(sintomas_tosse_forte, 'Tem tosse muito forte e seca?').
pergunta_sn(reacao_multiplos_locais, 'A reacao (comichao/vermelhidao) afeta multiplos locais do corpo ao mesmo tempo?').
pergunta_sn(alergia_local_trabalho, 'A reacao ocorre predominantemente no seu local de trabalho (ex: profissionais de saude)?').
pergunta_sn(reacao_local_zona_latex, 'A pele ficou vermelha/irritada exclusivamente na zona onde a luva ou elastico tocou?').