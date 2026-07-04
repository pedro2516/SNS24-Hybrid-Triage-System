:- encoding(utf8).

% ========================================================================
% LIGAÇÃO COM MODELOS MACHINE LEARNING (WEKA)
% Mapeia os identificadores dos grupos para os predicados gerados via ML
% ========================================================================

% triagem_grupo/3 invoca o respetivo ficheiro G1.pl até G5.pl na pasta RegrasWeka.
triagem_grupo(Doente, 1, Res) :- triagem_g1_ml(Doente, Res).
triagem_grupo(Doente, 2, Res) :- triagem_g2_ml(Doente, Res).
triagem_grupo(Doente, 3, Res) :- triagem_g3_ml(Doente, Res).
triagem_grupo(Doente, 4, Res) :- triagem_g4_ml(Doente, Res).
triagem_grupo(Doente, 5, Res) :- triagem_g5_ml(Doente, Res).