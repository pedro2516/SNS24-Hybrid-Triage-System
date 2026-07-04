:- encoding(utf8).

% ==============================================================
% MODELO MACHINE LEARNING - GRUPO 4
% Condicoes Cutaneas e Infeccoes de Pele
% Algoritmo: J48 (Decision Tree) extraído do Weka
% ==============================================================

triagem_g4_ml(Doente, Resultado) :-
    % A raiz da árvore é numérica, logo obtemos o valor primeiro
    obter_valor_escala(Doente, formigueiro, ValorFormigueiro),
    
    ( ValorFormigueiro > 0 -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, pele_comichao) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, pele_descamae_fininho) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, inchaco_rosto) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, reacoes_ao_sol) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, pele_empolada) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, pele_ligeiramente_vermelha) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, vermelhidao_persistente_nas_dobras) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, pequenas_manchas_menos_24h) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, feridas_nao_melhoram_com_cremes) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, pele_muito_seca) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, historico_angioedema_sem_sintomas_ativos) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, labio_inchado) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, ligeiro_inchaco_isolado) -> 
        Resultado = 'Nao Urgente'
        
    ; % Se o formigueiro for <= 0 e todos os sintomas acima forem "não"
      Resultado = 'Urgente'
    ).