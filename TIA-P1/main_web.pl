:- encoding(utf8).

% ======================================================================
% PONTO DE ENTRADA — MODO WEB
%
% Carrega todos os módulos do sistema EXCETO Interface/interface.pl.
% Usa Interface/interface_web.pl em substituição, que lança exceções
% em vez de ler do terminal.
% ======================================================================

% --- 1. Motor ---
:- consult('Motor/base_dados.pl').
:- consult('Motor/inferencia.pl').
:- consult('Motor/probabilidade.pl').
:- consult('Motor/triagem.pl').

% --- 2. Dicionário ---
:- consult('Dicionario/perguntas_gerais.pl').
:- consult('Dicionario/perguntas_g1.pl').
:- consult('Dicionario/perguntas_g2.pl').
:- consult('Dicionario/perguntas_g3.pl').
:- consult('Dicionario/perguntas_g4.pl').
:- consult('Dicionario/perguntas_g5.pl').
:- consult('Dicionario/pesos_sintomas.pl').

% --- 3. Conhecimento ---
:- consult('Conhecimento/base_conhecimento.pl').
:- consult('Conhecimento/base_conhecimento_weka.pl').
:- consult('Conhecimento/descoberta_doencas.pl').

% --- 4. Regras Weka ---
:- consult('RegrasWeka/G1.pl').
:- consult('RegrasWeka/G2.pl').
:- consult('RegrasWeka/G3.pl').
:- consult('RegrasWeka/G4.pl').
:- consult('RegrasWeka/G5.pl').

% --- 5. Interface Web (sem I/O de terminal) ---
:- consult('Interface/interface_web.pl').

% ======================================================================
% CONVERSÃO DE PRIORIDADES
% (Copiado de Interface/interface.pl, que não é carregado neste modo.)
% ======================================================================

simplificar_prioridade(emergencia,   'Urgente').
simplificar_prioridade(urgente,      'Urgente').
simplificar_prioridade(nao_urgente,  'Nao Urgente').
simplificar_prioridade(autocuidados, 'Nao Urgente').

% ======================================================================
% MOTOR WEB — Ponto de entrada para o backend Python.
%
% executar_triagem_web(+Doente, +Grupo, -Status)
%
%   Corre as duas fases de inferência (Weka + Regras Manuais) envoltas
%   em catch/3. Se o motor necessitar de uma resposta do utilizador,
%   interface_web.pl lança web_question_needed/1, que é aqui apanhada.
%
%   Status = diagnostico_ok      → resultado em resultado_diagnostico/5
%   Status = pergunta_necessaria → próxima pergunta em pending_question/3
% ======================================================================

:- dynamic resultado_diagnostico/5.

executar_triagem_web(Doente, Grupo, Status) :-
    retractall(resultado_diagnostico(_, _, _, _, _)),
    catch(
        executar_fases(Doente, Grupo, Status),
        web_question_needed(_),
        Status = pergunta_necessaria
    ).

executar_fases(Doente, Grupo, Status) :-
    % Fase 1 — Motor Weka (Machine Learning / Árvore de Decisão)
    triagem_grupo(Doente, Grupo, _ResultadoWeka),

    % Fase 2 — Regras Manuais (Decisão Clínica Final)
    ( once(descobrir_doenca_por_grupo(Doente, Grupo, Doenca, Prioridade, Acao, Explicacao)) ->
        simplificar_prioridade(Prioridade, PrioridadeFinal)
    ;
        Doenca         = 'Desconhecida',
        PrioridadeFinal = '-',
        Acao           = 'Aconselhamento SNS24',
        Explicacao     = 'Nao foi possivel determinar o protocolo clinico.'
    ),

    % Fase 3 — Probabilidade
    calcular_probabilidade(Doente, Prob),

    % Armazena o resultado para leitura pelo Python
    assertz(resultado_diagnostico(Doenca, PrioridadeFinal, Acao, Explicacao, Prob)),
    Status = diagnostico_ok.
