# PredialFix

<a id="readme-top"></a>

<br />
<div align="center">
  <a href="https://github.com/GoldenLeap/PredialFix">
    <img src="images/logo.png" alt="Logo" width="300" height="300">
  </a>

<h3 align="center">PredialFix</h3>

  <p align="center">
    O "PredialFix" será uma plataforma para gerenciar solicitações de manutenção predial no Senai. O sistema visa resolver problemas como a falta de transparência e a demora no atendimento de chamados, centralizando as solicitações e permitindo o acompanhamento de cada etapa até a resolução. O foco inicial é o desenvolvimento do Back-End, que fornecerá uma API RESTful para futuras integrações com interfaces de usuário (Front-End).
    <br />
</div>

## Sumário

- [Sobre o Projeto](#sobre-o-projeto)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Protótipo](#protótipo)
  - [Interface de Usuário (Figma)](#1-interface-de-usuário-figma)
  - [Metodologia Agil (Kanban)](#2-metodologia-agil-kanban)
  - [Arquitetura de Dados (DER)](#3-arquitetura-de-dados-der)
  - [Mapa de Endpoints](#4-mapa-de-endpoints)
  

## Sobre o Projeto

O "PredialFix" será uma plataforma para gerenciar solicitações de manutenção predial no Senai. O sistema visa resolver problemas como a falta de transparência e a demora no atendimento de chamados, centralizando as solicitações e permitindo o acompanhamento de cada etapa até a resolução. O foco inicial é o desenvolvimento do Back-End, que fornecerá uma API RESTful para futuras integrações com interfaces de usuário (Front-End).

<p align="right">(<a href="#readme-top">voltar para o topo</a>)</p>

### Tecnologias Utilizadas

* **Back-End:** [![Laravel][Laravel.com]][Laravel-url] com [![MySQL][MySQL.com]][MySQL-url]
* **Front-End:** [![Vue.js][Vue.js]][Vue-url] com [![Tailwind CSS][Tailwind.com]][Tailwind-url]

<p align="right">(<a href="#readme-top">voltar para o topo</a>)</p>

## Protótipo

O desenvolvimento do PredialFix seguiu uma abordagem de prototipagem em três níveis: Interface (UX/UI), Dados (Banco de dados) e Comunicação (API).

### 1. Interface de Usuário (Figma)
 * [Acesse o protótipo no Figma](https://www.figma.com/site/7rBeSDg6EBjocLUKzxxonh/PredialFix?node-id=0-1&t=87o2HwW8FBtxYwml-1)

### 2. Metodologia Agil (Kanban)
Para garantir a eficiência no desenvolvimento e a organização das entregas, o projeto utiliza a metodologia Kanban. Esta abordagem permite a visualização clara do fluxo de trabalho, auxiliando na identificação de gargalos e na priorização de tarefas críticas.

As atividades são divididas em tres estados principais, que refletem o ciclo de vida de cada funcionalidade da API:
- A Fazer: Tarefas priorizadas e prontas para o início do desenvolvimento.
- Em Andamento: Funcionalidades que estão sendo codificadas e testadas no ambiente de desenvolvimento.
- Concluido: Requisitos finalizados, documentados e com o merge realizado na branch principal.

* [Acesse o quadro kanban do projeto aqui](https://trello.com/b/LMRbT3a9/predialfix)
### 3. Arquitetura de Dados (DER)
 Planejado para garantir a **transparência total** exigida, o banco de dados conta com tabelas de histórico para auditoria de cada mudança de status e gestão de orçamentos.

O diagrama foi desenvolvido utilizando a ferramenta dbdiagram.io e ilustra como as tabelas se conectam:

- usuarios: Armazena os dados dos colaboradores, diferenciando-os por cargos (solicitante ou responsavel).
- chamados: A tabela central que registra o tipo de manutenção (Elétrica, Hidráulica, etc.), local, descrição e o status atual da tarefa.
- historico_chamados: Garante a rastreabilidade do sistema, armazenando cada mudança de status, a data da alteração e quem a realizou.
- orcamentos: Permite o registro de custos e fornecedores vinculados a um chamado específico, com um fluxo de aprovação próprio.

⛓️ Relacionamentos Principais
Usuário -> Chamados: Um usuário pode abrir múltiplos chamados (1:N).

Chamado -> Histórico: Cada chamado possui um rastro de eventos cronológicos para fins de auditoria (1:N).

Chamado -> Orçamentos: Um chamado pode ter um ou mais orçamentos vinculados para comparação de valores e peças (1:N).

## 4. Mapa de Endpoints 
 Abaixo estão as principais rotas planejadas:
 | Método | Rota | Descrição |
 | :--- | :--- | :---|
 | `POST` | `/api/login`| Autenticação e geração de Token de acesso |
 | `POST` | `/api/chamados`| Registro de nova solicitação |
 | `GET` | `/api/chamados` | Listagem geral com filtro de status |
 | `PATCH` | `/api/chamados/{id}/status` | Atualização do status do chamado |
 | `POST` | `/api/orcamentos` | Registro de custos para aprovação |
  
<p align="right">(<a href="#readme-top">voltar para o topo</a>)</p>

[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[MySQL.com]: https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white
[MySQL-url]: https://www.mysql.com/
[Tailwind.com]: https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white
[Tailwind-url]: https://tailwindcss.com/
