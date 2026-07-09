# Order State Machine CLI

Aplicação CLI em Ruby puro para gerenciar o ciclo de vida de pedidos usando uma máquina de estados implementada manualmente.

Este repositório foi pensado como uma entrega técnica com foco em qualidade, clareza e controle do domínio. O objetivo é demonstrar competências associadas a uma posição de nível sênior, incluindo modelagem, separação de responsabilidades, tratamento de erros e testes confiáveis.

## Requisitos

- Ruby 3.x
- Bundler

## Instalação

```bash
bundle install
```

## Como executar

```bash
ruby main.rb
```

## Como executar os testes

```bash
bundle exec rspec
```

## O que a aplicação faz

A CLI permite gerenciar pedidos pelos estados do ciclo de vida:

1. Criar pedido
2. Listar pedidos
3. Consultar pedido
4. Pagar pedido
5. Enviar pedido
6. Entregar pedido
7. Cancelar pedido
8. Sair

Os pedidos são mantidos em memória, de acordo com o escopo do teste, garantindo um design simples e focado sem persistência externa.

## Máquina de estados

Estados possíveis:

- `pending`
- `paid`
- `shipped`
- `delivered`
- `cancelled`

Transições permitidas:

```text
pending -> paid -> shipped -> delivered
pending -> cancelled
paid -> cancelled
```

Estados finais:

- `delivered`
- `cancelled`

Uma vez em estado final, o pedido não pode mais mudar de estado.

## Decisões técnicas e posicionamento sênior

### Modelo de domínio claro
A lógica de transição fica em `Order`, que encapsula o estado atual, o histórico e as regras de transição. Isso deixa o domínio explicitamente definido sem dependência de bibliotecas externas.

### Separação de responsabilidades
O projeto adota uma divisão limpa:

- `Order`: lógica de domínio e regras de negócio.
- `OrderRepository`: armazenamento e recuperação de pedidos em memória, com IDs sequenciais.
- `OrderCLI`: interface de usuário, menu e tratamento de entrada.

Essa separação ajuda a manter código testável e fácil de manter.

### Tratamento de erros robusto
Transições inválidas levantam uma exceção customizada (`Order::InvalidTransitionError`) e são capturadas na camada de CLI para informar o usuário sem quebrar o programa.

Busca de pedido por ID também é tratada com exceção específica (`OrderRepository::OrderNotFoundError`), garantindo que entradas inválidas não interrompam o fluxo principal.

### Escolha intencional de Ruby puro
O projeto evita gems de state machine como `aasm` ou `state_machines` para evidenciar o entendimento das regras de domínio e mostrar a capacidade de implementar uma máquina de estados com código direto e explícito.

## Testes

A suíte de testes foca na lógica de domínio, alinhada ao objetivo do desafio.

Cobertura inclui:

- estado inicial e histórico do pedido;
- transições válidas entre estados;
- prevenção de transições inválidas;
- comportamentos em estados finais;
- criação e busca de pedidos no repositório.

A camada de CLI não é testada automaticamente, conforme solicitado pelo enunciado.

## O que entregar

Este repositório mostra não apenas uma solução funcional, mas também:

- design orientado a objeto;
- responsabilidades bem definidas;
- tratamento de entrada e erros amigável;
- testes automatizados que validam a lógica de negócio.

Boa leitura e obrigado pela avaliação! 🚀
