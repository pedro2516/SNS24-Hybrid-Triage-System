:- encoding(utf8).

% ==============================================================
% MODELO MACHINE LEARNING - GRUPO 1
% Vias Aereas Inferiores e Pulmonares
% Algoritmo: J48 (Decision Tree) extraído do Weka
% ==============================================================

triagem_g1_ml(Doente, Resultado) :-
    % A estrutura ( A -> B ; C ) replica perfeitamente os ramos da árvore de decisão J48
    ( tem_sintoma(Doente, fala_normal) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, manchas_secas_asperas) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, estavel_apesar_sintomas) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, exposicao_pos_organicos) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, tosse_persistente_noturna) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, comichao_cara_garganta) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, uso_frequente_inalador) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, dor_facial) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, pingo_transparente) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, espirros_frequentes) -> 
        Resultado = 'Nao Urgente'
        
    ; % Se todas as respostas anteriores forem "não" (ou desconhecidas), entra no nó numérico
      obter_valor_escala(Doente, peito_pesado_ambientes_humidos, ValorPeito),
      
      ( ValorPeito =< 0 ->
          ( tem_sintoma(Doente, tosse_persistente) ->
              ( tem_sintoma(Doente, falta_de_ar_com_pieira) ->
                  Resultado = 'Urgente'
              ;
                  Resultado = 'Nao Urgente'
              )
          ;
              Resultado = 'Urgente'
          )
      ; % Caso contrário (ValorPeito > 0)
          ( tem_sintoma(Doente, muco_castanho) ->
              Resultado = 'Urgente'
          ;
              Resultado = 'Nao Urgente'
          )
      )
    ).