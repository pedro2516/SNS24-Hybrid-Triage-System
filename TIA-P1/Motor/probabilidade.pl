:- encoding(utf8).

% =====================================================================
% CÁLCULO DE PROBABILIDADE (VERSÃO FINAL CORRIGIDA)
% =====================================================================

calcular_probabilidade(Doente, ProbabilidadeFinal) :-
    % 1. PONTOS DE "SIM": Agora recolhe corretamente a variável 'Pts'
    findall(Pts, (sintoma(Doente, S), obter_peso(S, P), Pts is P * 0.95), PesosSim),
    sum_list(PesosSim, SomaSim),

    % 2. PONTOS DE "NÃO": Vale 50% do peso (Valor de Exclusão)
    findall(Pts, (nao_sintoma(Doente, S), obter_peso(S, P), Pts is P * 0.5), PesosNao),
    sum_list(PesosNao, SomaNao),

    % 3. PONTOS DE ESCALA: Proporcional ao valor (Valor * Peso / 10)
    findall(Pts, (sintoma(Doente, S, V), obter_peso(S, P), Pts is (V * P) / 10), PtosEscala),
    sum_list(PtosEscala, SomaEscala),

    % 4. PONTOS DE "NÃO SEI": Vale 25% do peso
    findall(Pts, (incerto_sintoma(Doente, S), obter_peso(S, P), Pts is P * 0.25), PtosIncertos),
    sum_list(PtosIncertos, SomaIncertos),

    % 5. CÁLCULO DO TOTAL POSSÍVEL (DENOMINADOR)
    findall(S, sintoma(Doente, S),          Ss1),
    findall(S, nao_sintoma(Doente, S),      Ss2),
    findall(S, incerto_sintoma(Doente, S),  Ss3),
    findall(S, sintoma(Doente, S, _),       Ss4),
    append([Ss1, Ss2, Ss3, Ss4], TodosLista),
    sort(TodosLista, Todos),
    findall(P, (member(S, Todos), obter_peso(S, P)), PesosTodos),
    sum_list(PesosTodos, TotalPossivel),

    % 6. PERCENTAGEM FINAL
    ( TotalPossivel =:= 0 ->
        ProbabilidadeFinal = 0
    ;
        PontosObtidos is SomaSim + SomaNao + SomaEscala + SomaIncertos,
        % Cálculo: (Pontos / Total) * 100
        ProbabilidadeFinal is round((PontosObtidos / TotalPossivel) * 100)
    ).