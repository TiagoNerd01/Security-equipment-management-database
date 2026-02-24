# Security Equipment Management Database

## 📌 Descrição do Projeto
Este projeto tem como objetivo desenvolver a modelagem de um banco de dados para um **Sistema de Controle de Distribuição de Equipamentos de Proteção Individual (EPI)**, baseado em uma planilha proveniente de um cenário real de controle de uniformes.

As entidades foram definidas a partir das necessidades observadas nesse processo, incluindo cadastro organizacional, controle de estoque, movimentações de equipamentos e processos administrativos relacionados à aquisição e devolução de EPIs.

O sistema busca estruturar essas informações de forma organizada, permitindo futura implementação em um banco de dados relacional.

---

## 🎯 Objetivos

Aplicar conceitos fundamentais de:

- Modelagem conceitual  
- Modelagem lógica  
- Estruturação de tabelas utilizando DDL (Data Definition Language)  
- Organização de dados baseada em regras de negócio reais  

Além disso, o projeto visa transformar um controle manual realizado em planilhas em uma estrutura adequada para sistemas de informação.

---

## 🌐 Domínio do Sistema

O domínio foi definido como **Security Equipment Management Database**, pois:

- Representa diretamente o problema tratado pelo sistema  
- Utiliza terminologia em inglês, facilitando o entendimento internacional  
- Segue o padrão comum na área de tecnologia para nomeação de projetos e sistemas  

---

## 🧩 Entidades Identificadas

As entidades foram organizadas em grupos conforme sua função dentro do sistema.

### Entidades cadastrais
- Funcionario  
- Unidade  
- Setor  
- tipo_epi  
- tamanho  
- fornecedor  
- usuario_sistema 

### Entidades operacionais
- estoque  
- entrega_epi  
- devolucao_epi  

### Entidades de controle de compras
- compra_epi  
- item_compra  

---
## 📊 Estrutura Funcional do Modelo

O modelo permite representar:

- Cadastro de funcionários e estrutura organizacional  
- Controle de tipos de EPIs e seus tamanhos  
- Controle de estoque por unidade  
- Registro de entregas de equipamentos  
- Registro de devoluções  
- Controle de fornecedores  
- Registro de compras de EPIs  
- Detalhamento dos itens comprados  
- Controle de usuários responsáveis pelas operações

---
## ⚙️ Padrões Utilizados

Para organização e padronização da modelagem foram adotados:

- Nomes de tabelas em **snake_case**
- Nomes descritivos para atributos
- Tipos de dados compatíveis com banco de dados relacionais
- Estrutura preparada para futura inclusão de **chaves estrangeiras**

**Referência utilizada:**
- Database Naming Standards

---

## 🤝 Colaboração

O desenvolvimento foi realizado de forma colaborativa entre os membros do grupo sendo eles:
-Tiago Santos
-Gustavo Muller
-Vitor Vinicius
-Luis
-Danilo
