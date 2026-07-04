:- encoding(utf8).

% ======================================================================
% INTERFACE WEB — Substitui Interface/interface.pl no modo web.
%
% Estratégia "Stateless via Exceção":
%   Em vez de ler a resposta do terminal (read_line_to_string),
%   este módulo:
%     1. Guarda a pergunta necessária no facto dinâmico pending_question/3.
%     2. Lança a exceção web_question_needed/1 para interromper
%        IMEDIATAMENTE a inferência e devolver o controlo ao backend Python.
%
% O predicado executar_triagem_web/3 em main_web.pl usa catch/3 para
% apanhar esta exceção de forma segura e devolver o estado correto.
% ======================================================================

:- dynamic pending_question/3.

% --- Substitui perguntar/2 do Interface/interface.pl ---
%
% Não usa read_line_to_string. Em vez disso:
%   - Verifica o dicionário para obter o texto da pergunta.
%   - Armazena em pending_question/3 (que o Python lê depois).
%   - Lança web_question_needed/1 para parar a inferência.

perguntar(_Doente, Sintoma) :-
    retractall(pending_question(_, _, _)),
    ( pergunta_escala(Sintoma, Texto) ->
        assertz(pending_question(escala, Sintoma, Texto))
    ; pergunta_sn(Sintoma, Texto) ->
        assertz(pending_question(sn, Sintoma, Texto))
    ;
        % Fallback para sintomas sem pergunta definida no dicionário
        atom_concat('O doente apresenta o sintoma: ', Sintoma, Texto),
        assertz(pending_question(sn, Sintoma, Texto))
    ),
    throw(web_question_needed(Sintoma)).

% --- Substitui obter_valor_escala/3 do Interface/interface.pl ---
%
% Necessário para as árvores de decisão Weka (G1.pl, etc.) que chamam
% obter_valor_escala/3 diretamente para sintomas numéricos.

obter_valor_escala(Doente, Sintoma, Valor) :-
    ( sintoma(Doente, Sintoma, V) ->
        Valor = V
    ;
        % O valor ainda não foi fornecido — lança exceção via perguntar/2.
        % A linha seguinte nunca é alcançada (perguntar lança exceção),
        % mas mantém a assinatura correta para o compilador Prolog.
        perguntar(Doente, Sintoma),
        sintoma(Doente, Sintoma, Valor)
    ).
