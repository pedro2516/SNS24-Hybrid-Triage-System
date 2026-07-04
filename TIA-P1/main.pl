:- encoding(utf8).

% ==============================================================
% SISTEMA INTELIGENTE DE APOIO À DECISÃO - TRIAGEM SNS24
% CARREGAMENTO DOS MÓDULOS (ESTRUTURA DE PASTAS)
% ==============================================================

% --- 1. Motor (Mecanismos internos e memória) ---
:- consult('Motor/base_dados.pl').
:- consult('Motor/inferencia.pl').
:- consult('Motor/probabilidade.pl').
:- consult('Motor/triagem.pl').

% --- 2. Dicionário (Tradução de sintomas e textos) ---
:- consult('Dicionario/perguntas_gerais.pl').
:- consult('Dicionario/perguntas_g1.pl').
:- consult('Dicionario/perguntas_g2.pl').
:- consult('Dicionario/perguntas_g3.pl').
:- consult('Dicionario/perguntas_g4.pl').
:- consult('Dicionario/perguntas_g5.pl').
:- consult('Dicionario/pesos_sintomas.pl').

% --- 3. Conhecimento (Regras Manuais da Parte A) ---
:- consult('Conhecimento/base_conhecimento.pl').
:- consult('Conhecimento/base_conhecimento_weka.pl').
:- consult('Conhecimento/descoberta_doencas.pl').

% --- 4. Regras Weka (Machine Learning da Parte B) ---
:- consult('RegrasWeka/G1.pl').
:- consult('RegrasWeka/G2.pl').
:- consult('RegrasWeka/G3.pl').
:- consult('RegrasWeka/G4.pl').
:- consult('RegrasWeka/G5.pl').

% --- 5. Interface (Interação com o Utilizador) ---
:- consult('Interface/interface.pl').

