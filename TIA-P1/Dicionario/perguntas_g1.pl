:- encoding(utf8).

:- multifile pergunta_sn/2.
:- multifile pergunta_escala/2.

% ===================================================
% --- G1: ASMA ---
% ===================================================
pergunta_sn(cianose_labios_unhas, 'Os labios ou as unhas apresentam uma cor azulada (cianose)?').
pergunta_sn(incapacidade_falar, 'A respiracao esta ofegante ao ponto de nao conseguir falar uma frase inteira?').
pergunta_sn(sonolencia, 'O doente esta invulgarmente sonolento ou a perder a forca?').
pergunta_sn(desorientado, 'O doente esta desorientado ou confuso?').
pergunta_escala(dificuldade_respirar_agora, 'Qual a intensidade da dificuldade em respirar neste exato momento?').
pergunta_sn(tosse_persistente, 'Apresenta uma tosse persistente ao longo do dia?').
pergunta_sn(tosse_persistente_noturna, 'Apresenta tosse persistente que agrava durante a noite?').
pergunta_sn(uso_frequente_inalador, 'Tem tido necessidade de usar o inalador frequentemente nos ultimos dias?').
pergunta_sn(tosse_ligeira, 'O doente apresenta apenas uma tosse ligeira e suportavel?').
pergunta_sn(comichao_garganta, 'Sente comichao na garganta?').
pergunta_sn(fala_normal, 'Consegue falar de forma normal e fluente sem se cansar?').

% ===================================================
% --- G1: ABPA (Aspergilose) ---
% ===================================================
pergunta_sn(falta_de_ar_em_repouso, 'Sente falta de ar mesmo estando em repouso absoluto?').
pergunta_sn(dor_toracica, 'Tem uma dor aguda no peito ao respirar?').
pergunta_sn(tosse_sangue, 'O doente tossiu sangue (hemoptise)?').
pergunta_sn(febre_persistente, 'Tem uma febre persistente que nao cede?').
pergunta_sn(cansaco_extremo, 'Sente um cansaco extremo e fora do normal?').
pergunta_sn(pieira_inalador, 'A pieira nao passa mesmo apos o uso do inalador de SOS?').
pergunta_sn(aumento_expetoracao, 'O doente notou um aumento substancial na quantidade de expetoracao?').
pergunta_escala(peito_pesado_ambientes_humidos, 'Qual a intensidade da sensacao de peito pesado em ambientes humidos?').
pergunta_escala(tosse_seca, 'Qual a intensidade da tosse seca que sente?').
pergunta_escala(aperto_peito, 'Qual a intensidade da sensacao de aperto no peito?').
pergunta_escala(fadiga, 'Qual o seu nivel de fadiga ou cansaco neste momento?').
pergunta_sn(exposicao_pos_organicos, 'Costuma estar exposto a poeiras agricolas, fenos ou aves?').
pergunta_sn(estavel_apesar_sintomas, 'Apesar do desconforto, sente-se clinicamente estavel?').

% ===================================================
% --- G1: ANIMAIS ---
% ===================================================
pergunta_sn(dificuldade_em_respirar_ou_engolir, 'Sente muita dificuldade em respirar ou ate mesmo em engolir saliva?').
pergunta_sn(inchaco_garganta, 'A garganta inchou rapidamente?').
pergunta_sn(chiado_apos_contacto_animal, 'Apos o contacto com o animal ficou com o peito a chiar?').
pergunta_sn(inchaco_ocular_acentuado, 'Os olhos incharam muito e rapidamente apos tocar no pelo/saliva do animal?').
pergunta_sn(manchas_secas_asperas, 'A pele tem manchas secas e asperas nas zonas de contacto?').
pergunta_sn(pingo_transparente, 'Apresenta apenas um ligeiro pingo transparente no nariz?').
pergunta_sn(comichao_cara_garganta, 'Apresenta comichao apenas na cara ou na garganta?').