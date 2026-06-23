# Agenda Eletrônica Pessoal

Uma aplicação móvel desenvolvida em **Flutter**, projetada para ajudar você a gerenciar seus contatos, organizá-los em grupos e agendar eventos com lembretes inteligentes por meio de notificações locais.

---

## Funcionalidades Principais

* **Gestão de Contatos (CRUD)**
  * Cadastro completo de contatos (Nome, Sobrenome, Telefone com máscara dinâmica e E-mail).
  * Avatar gerado automaticamente baseado nas iniciais do nome e com cor personalizada aleatória.
  * Filtro de busca em tempo real.
  * Ordenação flexível (Ordem alfabética A-Z/Z-A, Data de criação e Data de última atualização).
* **Organização em Grupos**
  * Agrupamento de contatos para fácil gerenciamento.
  * Adição e remoção rápida de membros ao grupo.
* **Agendamento de Eventos**
  * Criação de compromissos com data, horário e título.
  * Associação de contatos (participantes) aos eventos.
  * Configuração de múltiplos lembretes personalizados antes do evento começar.
* **Lembretes de Notificação Local**
  * Agendamento de notificações automáticas em segundo plano integradas ao sistema operacional com suporte a fuso horário.

---

## Tecnologias e Arquitetura

O projeto foi construído seguindo princípios de código limpo, separação de responsabilidades e desacoplamento de componentes (Injeção de Dependência).

* **Gerenciamento de Estado**: [Provider](https://pub.dev/packages/provider) para propagação de alterações de forma reativa e eficiente.
* **Injeção de Dependência (DI)**: Padrões de injeção via construtor nos controladores para aumentar a testabilidade e o desacoplamento. Via Provider em widgets responsívos.
* **Persistência Local**: [Hive](https://pub.dev/packages/hive), um banco de dados NoSQL rápido escrito em Dart pura, permitindo carregamento instantâneo offline.
* **Notificações Locais**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) combinado com [timezone](https://pub.dev/packages/timezone) para agendamento preciso de alarmes.

---

## Estrutura do Projeto

```text
lib/
├── constants/          # Constantes visuais, cores e strings de configuração
├── controllers/        # Controladores de negócio (ChangeNotifiers com Injeção de Dependência)
├── models/             # Modelos de dados imutáveis (Contact, Group, Event)
├── screens/            # Telas da aplicação organizadas por módulos
│   ├── contacts/       # Componentes e formulários de Contatos
│   ├── events/         # Componentes e formulários de Eventos
│   ├── groups/         # Componentes e formulários de Grupos
│   ├── home/           # Layout principal de navegação (Abas)
│   └── shared_widgets/ # Componentes visuais genéricos reutilizáveis
├── services/           # Serviços auxiliares (Notificação, Banco Hive, Toasts)
├── utils/              # Formatadores e utilitários de texto
└── main.dart           # Inicializador da aplicação e injeção de dependências global
```

---

## Como Executar o Projeto

### Pré-requisitos

* [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado na sua máquina (versão estável mais recente recomendada).
* Um dispositivo Android físico ou emulador conectado;
* Pode ser executado também em Linux, macOS e Windows; (cada plataforma exige um tipo de configuração específica) ;

### Passo a Passo

1. **Clonar o repositório:**

    ```bash
    git clone https://github.com/seu-usuario/agenda_eletronica_pessoal.git
    cd agenda_eletronica_pessoal
    ```

2. **Obter as dependências do Flutter:**

    ```bash
    flutter pub get
    ```

3. **Executar a aplicação:**
    Certifique-se de que há um dispositivo/emulador ativo (use `flutter devices` para listar) e execute:

    ```bash
    flutter run
    ```

---
