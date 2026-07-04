:- encoding(utf8).

% ==============================================================
% MODELO MACHINE LEARNING - GRUPO 5
% Vias Aereas Superiores e Olhos
% Algoritmo: J48 (Decision Tree) extraído do Weka
% ==============================================================

triagem_g5_ml(Doente, Resultado) :-
    ( tem_sintoma(Doente, comichao_vermelidao_48h) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, sintomas_congestao) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, peso_na_face) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, palpebras_inchadas) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, sensacao_areia_olho) -> 
        Resultado = 'Nao Urgente'
        
    ; % 1º Nó Numérico: Dor Facial
      obter_valor_escala(Doente, dor_facial, ValorDor),
      ( ValorDor > 0 ->
          ( ValorDor =< 4 -> 
              Resultado = 'Nao Urgente'
          ; 
              Resultado = 'Urgente'
          )
          
      ; % dor_facial <= 0 -> Avalia próxima escala
        obter_valor_escala(Doente, comichao_intensa_ambos_olhos, ValorComichao),
        ( ValorComichao > 0 -> 
            Resultado = 'Nao Urgente'
            
        ; % comichao_intensa_ambos_olhos <= 0 -> Retoma as perguntas S/N
          tem_sintoma(Doente, nariz_entupido) -> 
            Resultado = 'Nao Urgente'
            
        ; tem_sintoma(Doente, espirros_frequentes) -> 
            Resultado = 'Nao Urgente'
            
        ; tem_sintoma(Doente, corrimento_claro) -> 
            Resultado = 'Nao Urgente'
            
        ; % Todos os sintomas anteriores = N -> Avalia febre
          obter_valor_escala(Doente, febre, ValorFebre),
          ( ValorFebre =< 0 -> 
              Resultado = 'Urgente'
          ; ValorFebre =< 4 -> 
              Resultado = 'Nao Urgente'
          ; 
              Resultado = 'Urgente'
          )
        )
      )
    ).