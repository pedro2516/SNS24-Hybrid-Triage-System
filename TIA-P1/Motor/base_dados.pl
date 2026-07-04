:- encoding(utf8).

% ======================================================================
% BASE DE DADOS
% Factos dinâmicos que registam as respostas do doente durante a sessão.
% ======================================================================

% Declaração dos predicados dinâmicos usados pelo motor de inferência:
%   sintoma/2       — resposta binária (sim/não)
%   sintoma/3       — resposta numérica (escala 0-10)
%   nao_sintoma/2   — negação explícita de um sintoma
%   incerto_sintoma/2 — resposta de incerteza (ns = não sei)
:- dynamic sintoma/2.
:- dynamic sintoma/3.
:- dynamic nao_sintoma/2.
:- dynamic incerto_sintoma/2.

% Apaga todos os factos do doente atual, permitindo iniciar uma nova triagem.
limpar :-
    retractall(sintoma(_, _)),
    retractall(sintoma(_, _, _)),
    retractall(nao_sintoma(_, _)),
    retractall(incerto_sintoma(_, _)),
    write('Memoria limpa. Podes iniciar nova triagem.\n').