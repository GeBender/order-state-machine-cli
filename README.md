# Order State Machine CLI

Aplicação de linha de comando em Ruby puro para gerenciar o ciclo de vida de pedidos usando uma máquina de estados.

O projeto foi desenvolvido como teste técnico com foco em fundamentos de Ruby, modelagem de domínio, orientação a objetos, tratamento de erros e testes automatizados.

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

## Funcionalidades

A aplicação permite:

1. Criar pedido
2. Listar pedidos
3. Consultar pedido
4. Pagar pedido
5. Enviar pedido
6. Entregar pedido
7. Cancelar pedido
8. Sair

Os pedidos são mantidos em memória, conforme permitido pelo enunciado.

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

Nenhuma transição é permitida a partir de estados finais.

## Decisões técnicas

A implementação evita o uso de gems de state machine, como `aasm` ou `state_machines`, para manter a lógica explícita e aderente ao objetivo do teste.

A aplicação está dividida em três responsabilidades principais:

- `Order`: representa o domínio do pedido e concentra a regra de transição de estados.
- `OrderRepository`: armazena os pedidos em memória e gera identificadores sequenciais.
- `OrderCLI`: controla a interação com o usuário via terminal.

Transições inválidas lançam uma exceção específica, `Order::InvalidTransitionError`, tratada na camada de CLI para exibir mensagens amigáveis sem interromper o programa.

IDs inexistentes também são tratados por uma exceção específica, `OrderRepository::OrderNotFoundError`.

## Testes

Os testes automatizados cobrem principalmente a lógica de domínio:

- estado inicial do pedido;
- transições válidas;
- transições inválidas;
- estados finais;
- preservação do histórico;
- criação e busca de pedidos no repositório.

A camada de CLI não foi testada automaticamente, conforme permitido pelo enunciado.