# Security Equipment Management Database

## 📌 Descrição do Projeto
Este projeto tem como objetivo desenvolver a modelagem de um banco de dados para um **Sistema de Controle de Distribuição de Equipamentos de Proteção Individual (EPI)**, baseado em uma planilha proveniente de um cenário real de controle de uniformes.

As entidades foram definidas a partir das necessidades observadas nesse processo, incluindo:

- Funcionários  
- Unidades e setores  
- Tipos de EPI  
- Tamanhos  
- Controle de estoque  
- Registro de entregas  

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

As seguintes entidades foram definidas com base no domínio:

- Funcionario  
- Unidade  
- Setor  
- Tipo_epi  
- Tamanho  
- Estoque  
- Entrega_epi  

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

O desenvolvimento foi realizado de forma colaborativa utilizando o :contentReference[oaicite:0]{index=0}, permitindo:

- Versionamento do projeto  
- Organização dos scripts de DDL  
- Contribuições individuais dos integrantes através de commits  
- Integração das alterações por meio de Pull Requests
