:- encoding(utf8).

% ==========================================================
% INTERFACE E INTERAÇÃO COM O UTILIZADOR
% Gere a apresentação das perguntas, validação de inputs e 
% menus de navegação do sistema.
% ==========================================================

% O predicado perguntar/2 utiliza as definições do Dicionário.
% Se o sistema não encontrar uma pergunta específica, usa um fallback.

perguntar(Doente, Sintoma) :-
    % 1. Verifica se o sintoma está definido como pergunta de escala no dicionário
    ( pergunta_escala(Sintoma, TextoEscala) ->
        ler_escala(TextoEscala, Resposta),
        processar_resposta_escala(Doente, Sintoma, Resposta)
    ;
    % 2. Verifica se o sintoma está definido como pergunta de Sim/Não no dicionário
    pergunta_sn(Sintoma, TextoSN) ->
        ler_sn(TextoSN, Resposta),
        processar_resposta_sn(Doente, Sintoma, Resposta)
    ;
    % 3. Fallback: caso o sintoma não esteja no dicionário
        atom_concat('O doente apresenta o sintoma "', Sintoma, P1),
        atom_concat(P1, '"?', TextoFallback),
        ler_sn(TextoFallback, Resposta),
        processar_resposta_sn(Doente, Sintoma, Resposta)
    ).

% ==================================
% --- LEITURA E VALIDAÇÃO ---
% ==================================

% Lê e valida uma resposta de escala (0-10).
ler_escala(Texto, Valor) :-
    format('~n-> ~w~n   (0 = Nao sinto nada | 10 = O maximo possivel): ', [Texto]),
    read_line_to_string(user_input, Linha),
    ( atom_string(A, Linha), atom_number(A, N), integer(N), N >= 0, N =< 10 ->
        Valor = N
    ;
        write('   [ERRO] Resposta invalida. Introduza um numero inteiro entre 0 e 10.'), nl,
        ler_escala(Texto, Valor)
    ).

% Lê e valida uma resposta s/n/ns.
ler_sn(Texto, Resposta) :-
    format('~n-> ~w~n   (s = sim / n = nao / ns = nao sei): ', [Texto]),
    read_line_to_string(user_input, Linha),
    atom_string(R, Linha),
    ( memberchk(R, [s, n, ns]) ->
        Resposta = R
    ;
        write('   [ERRO] Resposta invalida. Responda apenas com "s", "n" ou "ns".'), nl,
        ler_sn(Texto, Resposta)
    ).

% ==================================
% --- PROCESSAMENTO DE RESPOSTAS ---
% ==================================
% Nota: Estes predicados fazem assert na Base de Dados (Motor)

processar_resposta_escala(Doente, Sintoma, Valor) :-
    asserta(sintoma(Doente, Sintoma, Valor)).

processar_resposta_sn(Doente, Sintoma, s) :-
    asserta(sintoma(Doente, Sintoma)).

processar_resposta_sn(Doente, Sintoma, n) :-
    asserta(nao_sintoma(Doente, Sintoma)), fail.

processar_resposta_sn(Doente, Sintoma, ns) :-
    asserta(incerto_sintoma(Doente, Sintoma)), fail.

% ==================================
% --- AUXILIARES DE ESCALA ---
% ==================================

% Retorna o valor de uma escala. Se não existir, pergunta.
obter_valor_escala(Doente, Sintoma, Valor) :-
    ( sintoma(Doente, Sintoma, V) ->
        Valor = V
    ;
      perguntar(Doente, Sintoma),
      sintoma(Doente, Sintoma, Valor)
    ).

% ==============================================
% --- MENUS DE ESCOLHA DE GRUPO ---
% ==============================================

mostrar_menu_grupos(GrupoNum) :-
    format('\n======================================================\n'),
    format('=== ESCOLHA O GRUPO DE SINTOMAS PARA AVALIACAO     ===\n'),
    format('======================================================\n'),
    format('1. Vias Aereas Inferiores e Pulmonares\n'),
    format('2. Contacto e Ingestao\n'),
    format('3. Reacoes a Farmacos e Procedimentos\n'),
    format('4. Condicoes Cutaneas e Infeccoes de Pele\n'),
    format('5. Vias Aereas Superiores e Olhos\n'),
    format('------------------------------------------------------\n'),
    ler_opcao_grupo(GrupoNum).

ler_opcao_grupo(GrupoNum) :-
    format('-> Introduza o numero do grupo (1-5): '),
    read_line_to_string(user_input, Linha),
    ( atom_string(A, Linha), atom_number(A, N), integer(N), N >= 1, N =< 5 ->
        GrupoNum = N
    ;
        write('   [ERRO] Opcao invalida. Escolha um numero entre 1 e 5.\n'),
        ler_opcao_grupo(GrupoNum)
    ).

obter_nome_grupo(1, 'Vias Aereas Inferiores e Pulmonares').
obter_nome_grupo(2, 'Contacto e Ingestao').
obter_nome_grupo(3, 'Reacoes a Farmacos e Procedimentos').
obter_nome_grupo(4, 'Condicoes Cutaneas e Infeccoes de Pele').
obter_nome_grupo(5, 'Vias Aereas Superiores e Olhos').

% ==============================================================
% --- MENU PRINCIPAL DA TRIAGEM (WEKA + PARTE A) ---
% ==============================================================

triagem(Doente) :-
    mostrar_menu_grupos(GrupoNum),
    obter_nome_grupo(GrupoNum, NomeGrupo),
    format('~n[A processar dados para: ~w]~n', [NomeGrupo]),
    
    % 1. Aplica o Weka internamente (Machine Learning)
    ( triagem_grupo(Doente, GrupoNum, _ResultadoWeka) ->
        
        % 2. Aplica as regras Manuais (Decisao Clinica Final)
        ( once(descobrir_doenca_por_grupo(Doente, GrupoNum, Doenca, PrioridadeOriginal, Acao, Explicacao)) -> 
            simplificar_prioridade(PrioridadeOriginal, PrioridadeFinal)
        ; 
            Doenca = 'Desconhecida', PrioridadeFinal = '-', Acao = '-', Explicacao = '-' 
        ),
        
        % 3. Calcula a probabilidade do quadro
        calcular_probabilidade(Doente, Prob),
        
        % 4. Imprime o Relatorio Final com apenas UMA prioridade
        format('\n======================================================\n'),
        format('===        RELATORIO FINAL DE TRIAGEM SNS24        ===\n'),
        format('======================================================\n'),
        format(' Doente:                    ~w\n', [Doente]),
        format(' Grupo de Sintomas:         ~w\n', [NomeGrupo]),
        format(' Suspeita Clinica:          ~w\n', [Doenca]),
        format(' Prioridade:                ~w\n', [PrioridadeFinal]),
        format(' Acao Recomendada:          ~w\n', [Acao]),
        format(' Justificacao:              ~w\n', [Explicacao]),
        format(' Confianca no Diagnostico:  ~w%\n', [Prob]),
        format('======================================================\n')
    ;
        write('\nErro: Nao foi possivel processar o modelo de triagem.\n')
    ).

% ==============================================================
% CONVERSAO DE PRIORIDADES PARA A TABELA FINAL
% ==============================================================
simplificar_prioridade(emergencia, 'Urgente').
simplificar_prioridade(urgente, 'Urgente').
simplificar_prioridade(nao_urgente, 'Nao Urgente').
simplificar_prioridade(autocuidados, 'Nao Urgente').

