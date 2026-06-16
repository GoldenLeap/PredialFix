# PredialFix - Documentação Oficial

## 1. Visão Geral do Projeto

### 1.1 Introdução
O **PredialFix** é uma plataforma de gerenciamento de solicitações de manutenção predial desenvolvida para o Senai. O sistema visa solucionar problemas como a falta de transparência e demora no atendimento de chamados, centralizando todas as solicitações em um único local e permitindo o acompanhamento detalhado de cada etapa até a resolução.

### 1.2 Objetivos Principais
- Centralizar o gerenciamento de chamados de manutenção predial
- Proporcionar transparência no acompanhamento de solicitações
- Reduzir o tempo de atendimento e resolução de chamados
- Manter histórico completo de todas as alterações de status
- Gerenciar orçamentos associados aos chamados

---

## 2. Arquitetura do Sistema

### 2.1 Stack Tecnológica

#### Backend
- **Framework**: Laravel 12.x
- **Linguagem**: PHP 8.2+
- **Autenticação**: Laravel Fortify
- **Admin Panel**: Filament 5.0
- **Real-time**: Laravel Reverb
- **ORM**: Eloquent
- **Testing**: Pest PHP

#### Frontend
- **Framework**: Vue.js 3.x
- **Renderização**: Inertia.js
- **CSS**: Tailwind CSS 4.x
- **UI Components**: Reka UI + Lucide Icons
- **Build Tool**: Vite 7.x
- **TypeScript**: 5.x

### 2.2 Estrutura de Pastas
```
chamados/
├── backend/          # Código Laravel
│   ├── app/         # Models, Controllers, Providers
│   ├── bootstrap/   # Arquivos de inicialização
│   ├── config/      # Configurações do sistema
│   ├── database/    # Migrations, Seeders, Factories
│   ├── public/      # Arquivos públicos
│   ├── resources/   # Views Blade
│   ├── routes/      # Rotas da aplicação
│   ├── storage/     # Logs, cache, uploads
│   └── tests/       # Testes automatizados
├── frontend/         # Código Vue.js
│   ├── resources/   # Componentes, Pages, JS/TS
│   └── [configs]    # package.json, vite.config, etc.
├── docs/            # Documentação
└── imagens/         # Imagens do projeto
```

---

## 3. Modelagem de Dados

### 3.1 Diagrama de Entidade-Relacionamento (DER)

```
Users (1) ──→ (N) Chamados
                      │
                      ├─── (1) ──→ (N) HistoricoChamados
                      │
                      └─── (1) ──→ (N) Orcamentos
```

### 3.2 Entidades

#### 3.2.1 Users (Usuários)
Tabela padrão do Laravel para autenticação de usuários.

#### 3.2.2 Chamados
| Campo | Tipo | Descrição | Restrições |
|-------|------|-----------|------------|
| id | BIGINT | Chave primária | AUTO_INCREMENT |
| usuario_id | BIGINT | ID do usuário que criou o chamado | FK → users.id |
| tipo | ENUM | Tipo de manutenção | 'Elétrica', 'Hidráulica', 'Infraestrutura', 'Outros' |
| local | VARCHAR | Localização do problema | Obrigatório |
| descricao | TEXT | Descrição detalhada do problema | Obrigatório |
| prioridade | ENUM | Nível de prioridade | 'Baixa', 'Média', 'Alta' |
| status | ENUM | Status do chamado | 'Aberto', 'Em Análise', 'Em Execução', 'Concluído' (padrão: 'Aberto') |
| created_at | TIMESTAMP | Data de criação | AUTO |
| updated_at | TIMESTAMP | Data de atualização | AUTO |

#### 3.2.3 HistoricoChamados
| Campo | Tipo | Descrição | Restrições |
|-------|------|-----------|------------|
| id | BIGINT | Chave primária | AUTO_INCREMENT |
| chamado_id | BIGINT | ID do chamado | FK → chamados.id |
| status_anterior | VARCHAR | Status anterior à alteração | Obrigatório |
| status_novo | VARCHAR | Novo status do chamado | Obrigatório |
| alterado_por | BIGINT | ID do usuário que alterou | FK → users.id |
| data_alteracao | TIMESTAMP | Data da alteração | DEFAULT CURRENT_TIMESTAMP |

#### 3.2.4 Orcamentos
| Campo | Tipo | Descrição | Restrições |
|-------|------|-----------|------------|
| id | BIGINT | Chave primária | AUTO_INCREMENT |
| chamado_id | BIGINT | ID do chamado associado | FK → chamados.id |
| fornecedor | VARCHAR | Nome do fornecedor | Obrigatório |
| valor | DECIMAL(10,2) | Valor do orçamento | Obrigatório |
| descricao_pecas | TEXT | Descrição das peças/serviços | Obrigatório |
| status | ENUM | Status do orçamento | 'pendente', 'aprovado', 'rejeitado' (padrão: 'pendente') |
| created_at | TIMESTAMP | Data de criação | AUTO |
| updated_at | TIMESTAMP | Data de atualização | AUTO |

---

## 4. Funcionalidades do Sistema

### 4.1 Gerenciamento de Chamados
- **Criar Chamado**: Usuários podem abrir novos chamados informando tipo, local, descrição e prioridade
- **Listar Chamados**: Visualização de todos os chamados com filtros e ordenação
- **Visualizar Detalhes**: Acesso completo ao histórico, orçamentos e informações do chamado
- **Editar Chamado**: Atualização das informações do chamado
- **Alterar Status**: Transição de status com registro automático no histórico
- **Excluir Chamado**: Remoção de chamados (soft delete opcional)

### 4.2 Histórico de Alterações
- Registro automático de todas as mudanças de status
- Informações sobre quem alterou e quando
- Visualização do fluxo completo do chamado

### 4.3 Gerenciamento de Orçamentos
- Associação de orçamentos a chamados
- Registro de fornecedor, valor e descrição de peças
- Controle de status (pendente, aprovado, rejeitado)

### 4.4 Autenticação e Autorização
- Login/Logout seguro via Laravel Fortify
- Gerenci
A tabela abaixo classifica as funcionalidades do projeto de acordo com a metodologia MoSCoW:

| Categoria | Funcionalidade | Descrição |
|-----------|----------------|-----------|
| **Must Have** (Deve Ter) | Autenticação de Usuários | Sistema de login/logout seguro |
| **Must Have** | Criar Chamado | Funcionalidade básica de abertura de chamados |
| **Must Have** | Listar Chamados | Visualização de todos os chamados |
| **Must Have** | Visualizar Detalhes do Chamado | Acesso às informações completas |
| **Must Have** | Alterar Status do Chamado | Transição de status com histórico |
| **Must Have** | Histórico de Alterações | Registro automático de mudanças |
| **Should Have** (Deveria Ter) | Editar Chamado | Atualização de informações |
| **Should Have** | Gerenciamento de Orçamentos | Associação de orçamentos aos chamados |
| **Should Have** | Filtros e Ordenação | Busca avançada de chamados |
| **Should Have** | Painel Admin (Filament) | Interface administrativa |
| **Could Have** (Poderia Ter) | Notificações em Tempo Real | Alertas via Laravel Reverb |
| **Could Have** | Upload de Anexos | Adição de imagens/documentos aos chamados |
| **Could Have** | Relatórios e Gráficos | Análises de desempenho |
| **Could Have** | Integração com E-mail | Notificações por e-mail |
| **Won't Have** (Não Terá) | Aplicativo Mobile | Versão para dispositivos móveis (versão atual) |
| **Won't Have** | Integração com ERP | Conexão com sistemas externos (versão atual) |

---

## 6. Guia de Instalação

### 6.1 Pré-requisitos  
- PHP ≥ 8.2
- Composer
- Node.js ≥ 20
- NPM ou Yarn
- MySQL ≥ 8.0 ou PostgreSQL ≥ 14
- Git

### 6.2 Passos de Instalação

1. **Clone o repositório**
```bash
git clone <url-do-repositorio>
cd PredialFix/chamados
```

2. **Configuração do Backend**
```bash
cd backend/src
composer install
cp .env.example .env
php artisan key:generate
```

3. **Configuração do Banco de Dados**
Edite o arquivo `.env` com as credenciais do seu banco:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=predialfix
DB_USERNAME=seu_usuario
DB_PASSWORD=sua_senha
```

4. **Execute as Migrations**
```bash
php artisan migrate
```

5. **Configuração do Frontend**
```bash
cd ../../frontend
npm install
```

6. **Inicie o Servidor de Desenvolvimento**
```bash
# Terminal 1 - Backend
cd ../backend/src
php artisan serve

# Terminal 2 - Frontend
cd ../../frontend
npm run dev
```

Acesse o sistema em: `http://localhost:8000`

---

## 7. API Endpoints

### 7.1 Chamados
| Método | Rota | Descrição | Autenticação |
|--------|------|-----------|--------------|
| GET | /chamados | Listar todos os chamados | Sim |
| GET | /chamados/create | Formulário de criação | Sim |
| POST | /chamados | Criar novo chamado | Sim |
| GET | /chamados/{chamado} | Visualizar detalhes | Sim |
| GET | /chamados/{chamado}/edit | Formulário de edição | Sim |
| PUT/PATCH | /chamados/{chamado} | Atualizar chamado | Sim |
| DELETE | /chamados/{chamado} | Excluir chamado | Sim |

---

## 8. Metodologia de Desenvolvimento

### 8.1 Metodologia Ágil - Kanban
O projeto utiliza a metodologia Kanban para organizar o fluxo de trabalho:
- **A Fazer**: Tarefas priorizadas e prontas para desenvolvimento
- **Em Andamento**: Funcionalidades sendo codificadas e testadas
- **Concluído**: Requisitos finalizados, documentados e mergeados

Quadro Kanban: [Acesse o Trello](https://trello.com/b/LMRbT3a9/predialfix)

### 8.2 Protótipo de Interface
Protótipo Figma: [Acesse o Figma](https://www.figma.com/site/7rBeSDg6EBjocLUKzxxonh/PredialFix)

---

## 9. Equipe do Projeto

- **Desenvolvedores**: [Gabriel Ferreira, Gabriel Bernardi]



---

## 10. Licença

MIT License - Veja o arquivo LICENSE para mais detalhes.

---

## 11. Contato

Para dúvidas ou sugestões, entre em contato com a equipe de desenvolvimento.
