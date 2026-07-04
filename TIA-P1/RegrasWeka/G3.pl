:- encoding(utf8).

% ==============================================================
% MODELO MACHINE LEARNING - GRUPO 3
% Reacoes a Farmacos e Procedimentos
% Algoritmo: J48 (Decision Tree) extraído do Weka
% ==============================================================

triagem_g3_ml(Doente, Resultado) :-
    ( tem_sintoma(Doente, estavel_apesar_sintomas) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, pequenas_alteracoes_cutaneas_isoladas) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, comichao_ligeira_tardio_apos_tomar_farmaco) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, dormencia_prolongada_sem_dor) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, pequeno_inchaco_contido_no_local) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, vermelidao_local_persistente) -> 
        Resultado = 'Nao Urgente'
        
    ; tem_sintoma(Doente, dormencia_mais_de_24_horas) -> 
        Resultado = 'Nao Urgente'
        
    ; % Se todas as respostas anteriores forem "não"
      Resultado = 'Urgente'
    ).