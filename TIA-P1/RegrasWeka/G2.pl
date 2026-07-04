:- encoding(utf8).

% ==============================================================
% MODELO MACHINE LEARNING - GRUPO 2
% Contacto e Ingestao
% Algoritmo: J48 (Decision Tree) extraído do Weka
% ==============================================================

triagem_g2_ml(Doente, Resultado) :-
    ( tem_sintoma(Doente, historico_anafilaxia) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, sintomas_apos_ingestao) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, reacao_local_zona_latex) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, alergia_local_trabalho) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, reacao_multiplos_locais) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, comichao_local_picada) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, inchaco_local_picada) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, picada_piorou_24h) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, reacoes_passadas) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, picada_pus) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, marcas_leves_pele) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, comichao_garganta) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, picada_quente) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, lacrimejo_apos_comer) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, comichao_labios_boca) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, espirros_apos_comer) -> 
        Resultado = 'Nao Urgente'
        
    ; % Se todas as respostas acima forem "não", verifica a escala de dor
      obter_valor_escala(Doente, dor_aguda_local_picada, ValorDor),
      
      ( ValorDor =< 0 ->
          Resultado = 'Urgente'
      ; ValorDor =< 4 ->
          Resultado = 'Nao Urgente'
      ;
          Resultado = 'Urgente'
      )
    ).