:- encoding(utf8).

% ==============================================================
% TRIAGEM E RELATÓRIO
% ==============================================================

% Ponto de entrada principal: corre o motor de inferência e imprime o relatório.
diagnosticar(Doente) :-
    triagem(Doente, Doenca, PrioridadeOriginal, Acao, Explicacao),
    simplificar_prioridade(PrioridadeOriginal, PrioridadeFinal),
    calcular_probabilidade(Doente, Prob),
    format('\n==================================\n'),
    format('=== RESULTADO DA TRIAGEM SNS24 ===\n'),
    format('==================================\n'),
    format('Doente: ~w\n', [Doente]),
    format('Suspeita Clinica: ~w\n', [Doenca]),
    format('Prioridade: ~w\n', [PrioridadeFinal]),
    format('Acao recomendada: ~w\n', [Acao]),
    format('Justificacao: ~w\n', [Explicacao]),
    format('Probabilidade do Quadro Clinico: ~w%\n', [Prob]),
    format('==================================\n').