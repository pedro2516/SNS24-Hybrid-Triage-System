# Sistema de Triagem SNS24

Trabalho prático desenvolvido para a unidade curricular de **Técnicas de Inteligência Artificial (TIA)**.

_Nota: Este repositório é uma cópia para fins de portfólio pessoal._

## Descrição

Este projeto consiste no desenvolvimento de um sistema inteligente de suporte à triagem clínica, inspirado nos protocolos da **Linha SNS 24**. O objetivo principal foi aproximar os sistemas periciais lógicos tradicionais dos modernos agentes de conversação baseados em linguagem natural.

O sistema foi desenhado e implementado em duas fases evolutivas:

- **Parte 1 (TIA-P1):** Um sistema pericial simbólico desenvolvido em **SWI-Prolog** que funde a lógica de inferência clínica baseada em regras com modelos de classificação de Machine Learning (Árvores de Decisão J48) extraídos do **Weka**.
- **Parte 2 (TIA-P2):** Uma extensão do sistema para um assistente conversacional automatizado com arquitetura **RAG (Retrieval-Augmented Generation)**, recorrendo a LLMs locais via **Ollama** e garantindo salvaguardas estritas contra alucinações clínicas.

## Autores

- Sérgio Paulo Vieira Carvalho [@serginho355](https://github.com/serginho355)
- Afonso Martim Carvalho Leite [@afonsooleite](https://github.com/afonsooleite)
- Pedro Manuel Mendes Neves [@pedro2516](https://github.com/pedro2516)
- Filipa Mendes de Castro Pinto [@filipamcp](https://github.com/filipamcp)
- Rodrigo Santiago Faria Fonseca Abreu [@rodrigoo-abreu](https://github.com/rodrigoo-abreu)
  
## Arquitetura

### Parte 1: Inferência Simbólica e ML (Prolog + Weka)

- **Base de Conhecimento (`base_conhecimento.pl`):** Modela a lógica determinista de encaminhamento de pacientes em 4 níveis de prioridade (_Emergência_, _Urgente_, _Consulta_ e _Auto-Cuidado_).
- **Motor de Machine Learning (`RegrasWeka/`):** Incorpora as regras condicionais extraídas diretamente das árvores J48 do _Weka_ para pré-classificar os grupos de sintomas.
- **Avaliação Probabilística (`probabilidade.pl`):** Calcula pesos de confiança estruturais com base na afirmação, incerteza ou exclusão de sintomas.
- **Interface Web Stateless (`interface_web.pl`):** Interrompe o processo de inferência através do tratamento de exceções sempre que são necessários dados do utilizador, tornando o fluxo compatível com arquiteturas web _stateless_.

### Parte 2: IA Generativa e RAG Conversacional (Python + LangChain)

- **Vector Store e Ingestão (`Chroma`):** Processa os protocolos médicos brutos (`protocolos_triagem.txt`) em segmentos de texto (_chunks_) indexados e convertidos em _embeddings_ com o modelo `nomic-embed-text`.
- **Fluxo RAG Local (`app.py`):** Utiliza o modelo `llama3.2` configurado com `temperature=0.0` para garantir um alinhamento absoluto com as fontes médicas oficiais.
- **Salvaguardas de Segurança:** Implementadas através de _prompts_ estruturados que ativam uma regra estrita de não-alucinação e matrizes de especificidade clínica.

## Estrutura

```text
├── TIA-P1/                    — Motor de Inferência Simbólica e Base de Conhecimento
│   ├── Motor/                 — Mecanismos de inferência, pesos e asserções em base de dados
│   ├── Dicionario/            — Léxico clínico que mapeia sintomas para linguagem natural
│   ├── RegrasWeka/            — Segmentos lógicos das Árvores de Decisão J48 (G1 a G5)
│   ├── Conhecimento/          — Protocolos médicos base e regras de triagem de sintomas
│   ├── Interface/             — Definições de IO para terminal CLI e ponte Web Stateless
│   └── web/                   — Conector Flask em Python para ligar a interface ao PySWIP
│
├── TIA-P2/                    — Assistente Conversacional RAG e IA Generativa
│   ├── app.py                 — Servidor Flask principal que orquestra o LangChain e o Ollama
│   ├── index.html             — Interface web interativa do cliente de chat da triagem
│   ├── requisitos_triagem.txt — Base de protocolos em texto otimizada para divisão em chunks
│   └── requirements.txt       — Manifesto de dependências do ecossistema de IA em Python
```

## Instalação e Configuração

### Requisitos Prévios

- Python 3.10 ou superior
- SWI-Prolog (com as variáveis de ambiente configuradas para o correto funcionamento do PySWIP)
- Ollama instalado e configurado com os modelos llama3.2 e nomic-embed-text

### Executar Parte 1

- cd TIA-P1/web
- pip install -r requirements.txt
- python backend/app.py
- http://localhost:5000

### Executar Parte 2

- cd cd TIA-P2
- pip install -r requirements.txt
- python app.py
- http://localhost:1338

## Tecnologias Principais

- Linguagens: Prolog, Python, HTML5/CSS3.
- Ciência de Dados / Machine Learning: Weka UI (Árvores J48).
- Ecossistema de IA Generativa: LangChain Core, ChromaDB, Ollama Embeddings & LLM.
- Ambiente Web: Flask, ponte de integração PySWIP.
