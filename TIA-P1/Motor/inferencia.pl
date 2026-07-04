:- encoding(utf8).

% =====================================================================
% MOTOR DE INFERÊNCIA
% Capaz de avaliar se um doente apresenta um dado sintoma, consultando
% a base de dados ou perguntando ao utilizador caso necessário.
% =====================================================================

% Regra 1: O sintoma foi confirmado pelo utilizador (resposta Sim/Não = sim).
tem_sintoma(Doente, Sintoma) :-
    sintoma(Doente, Sintoma), !.

% Regra 2: O sintoma foi avaliado por escala e o valor é significativo (>= 5).
tem_sintoma(Doente, Sintoma) :-
    sintoma(Doente, Sintoma, Valor),
    Valor >= 5, !.

% Regra 3: O sintoma foi avaliado por escala mas o valor é insuficiente (< 5).
tem_sintoma(Doente, Sintoma) :-
    sintoma(Doente, Sintoma, Valor),
    Valor < 5, !, fail.

% Regra 4: O sintoma foi negado pelo utilizador.
tem_sintoma(Doente, Sintoma) :-
    nao_sintoma(Doente, Sintoma), !, fail.

% Regra 5: O utilizador indicou que não sabe (ns).
tem_sintoma(Doente, Sintoma) :-
    incerto_sintoma(Doente, Sintoma), !, fail.

% Regra 6: Sintoma ainda desconhecido — pergunta ao utilizador.
tem_sintoma(Doente, Sintoma) :-
    perguntar(Doente, Sintoma),
    tem_sintoma(Doente, Sintoma).