# 🧬 AgroGen - Sistema Digital de Gestão da Sociobiodiversidade e Rastreabilidade de Material Genético

Este repositório contém a implementação física do Banco de Dados para o projeto **AgroGen**, desenvolvido como parte da **Experiência Prática 4 (AT 4)**.

O sistema visa garantir a rastreabilidade de material genético vegetal, conectando redes de agricultores guardiões a institutos de pesquisa científica, monitorando desde trocas de sementes crioulas até análises laboratoriais avançadas.

## 📂 Estrutura do Repositório

O projeto foi estruturado em 4 scripts SQL sequenciais para garantir a integridade e organização do banco de dados PostgreSQL.

### 📄 1. `1_criacao_tabelas.sql` (DDL)
Responsável por criar a estrutura do banco.
* **Arquitetura Híbrida (Best Practice):** Utilizamos `SERIAL` (Inteiros) para chaves primárias internas (performance) e colunas `codigo` (VARCHAR) para identificadores externos visíveis ao usuário (ex: `USR-01`, `LOT-05`).
* **Normalização:** Estrutura normalizada até a 3FN.
* **Integridade:** Definição de Chaves Estrangeiras (FK) e restrições `UNIQUE`.

### 📄 2. `2_povoamento.sql` (DML - Insert)
Script de carga massiva de dados para simular um ambiente real de produção.
* **Volume de Dados:**
    * 30 Usuários e 19 Guardiões.
    * 10 Instituições e 20 Comunidades.
    * 77 Análises Laboratoriais e 70 Trocas registradas.
    * 46 Plantios e 28 Lotes de Sementes.
* **Consistência:** Inserções respeitando a ordem de dependência referencial.

### 📄 3. `3_consultas.sql` (DQL - Select)
Conjunto de **10 consultas estratégicas** que demonstram a extração de inteligência do banco de dados.
* **Complexidade:** Uso de `INNER JOIN` (até 5 tabelas), `GROUP BY`, `COUNT`, `SUM` e filtros lógicos.
* **Exemplos de Relatórios:**
    * Rastreabilidade completa de trocas.
    * Ranking de estoque por espécie.
    * Mapeamento físico de biobancos.
    * Auditoria de movimentações.

### 📄 4. `4_manipulacao.sql` (DML - Update/Delete)
Scripts para manutenção e correção de dados.
* **Técnica Avançada:** Uso de **Subqueries** para localizar registros pelo código externo (ex: `WHERE codigo = 'USR-01'`) antes de atualizar ou deletar, simulando uma aplicação real onde o usuário não conhece o ID numérico interno.

---

## 🚀 Como Executar

Para evitar erros de chave estrangeira (Foreign Key), é **obrigatório** seguir a ordem abaixo no seu SGBD (DBeaver, pgAdmin, etc.):

1.  Executar **`1_criacao_tabelas.sql`** (Limpa o banco e cria as tabelas).
2.  Executar **`2_povoamento.sql`** (Insere a massa de dados).
3.  Executar **`3_consultas.sql`** (Gera os relatórios de teste).
4.  Executar **`4_manipulacao.sql`** (Testa as atualizações e exclusões).

---

## 🛠 Tecnologias Utilizadas
* **Linguagem:** SQL (PostgreSQL Dialect)
* **Ferramenta:** DBeaver / pgAdmin
* **Modelagem:** Conceito de Identificadores Semânticos (`USR-01`, `BIO-02`) para melhor legibilidade.

---
**Autora:** Kamilla de Paula
