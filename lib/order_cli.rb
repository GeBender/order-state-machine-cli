# frozen_string_literal: true

require_relative "order_repository"

class OrderCLI
  def initialize(repository: OrderRepository.new)
    @repository = repository
    @running = true
  end

  def start
    puts "=== Gerenciador de Pedidos ==="

    while @running
      display_menu
      handle_option(read_option)
    end
  end

  private

  attr_reader :repository

  def display_menu
    puts
    puts "════════════════════════════════════════"
    puts "            Menu de Pedidos"
    puts "════════════════════════════════════════"
    puts "1. Criar pedido"
    puts "2. Listar pedidos"
    puts "3. Consultar pedido"
    puts "4. Pagar pedido"
    puts "5. Enviar pedido"
    puts "6. Entregar pedido"
    puts "7. Cancelar pedido"
    puts "8. Sair"
    puts "════════════════════════════════════════"
    print "Escolha uma opção: "
  end

  def read_option
    gets&.strip
  end

  def handle_option(option)
    case option
    when nil
      exit_program
    when "1"
      create_order
    when "2"
      list_orders
    when "3"
      show_order
    when "4"
      transition_order(:pay!, "pago")
    when "5"
      transition_order(:ship!, "enviado")
    when "6"
      transition_order(:deliver!, "entregue")
    when "7"
      transition_order(:cancel!, "cancelado")
    when "8"
      exit_program
    else
      print_error("Opção inválida. Escolha uma opção entre 1 e 8.")
    end
  end

  def create_order
    order = repository.create

    print_success("Pedido ##{order.id} criado com sucesso! Estado: #{order.state}")
  end

  def list_orders
    orders = repository.all

    if orders.empty?
      print_notice("Nenhum pedido criado.")
      return
    end

    puts
    puts "📦 Pedidos existentes"
    puts "────────────────────────────────────────"
    orders.each do |order|
      puts "##{order.id} - #{order.state}"
    end
    puts
  end

  def show_order
    order = find_order_from_input

    return unless order

    puts
    puts "🔎 Detalhes do pedido ##{order.id}"
    puts "────────────────────────────────────────"
    puts "Estado atual: #{order.state}"
    puts "Histórico: #{order.history.join(' -> ')}"
    puts
  end

  def transition_order(action, success_description)
    order = find_order_from_input

    return unless order

    order.public_send(action)

    print_success("Pedido ##{order.id} #{success_description} com sucesso! Estado: #{order.state}")
  rescue Order::InvalidTransitionError => error
    print_error(error.message)
  end

  def find_order_from_input
    id = read_order_id

    return unless id

    repository.find(id)
  rescue OrderRepository::OrderNotFoundError => error
    print_error(error.message)
    nil
  end

  def read_order_id
    print "Informe o número do pedido: "

    input = gets&.strip

    unless valid_integer?(input)
      print_error("Informe um número de pedido válido.")
      return nil
    end

    input.to_i
  end

  def valid_integer?(input)
    input&.match?(/\A\d+\z/)
  end

  def print_success(message)
    puts
    puts "✅ #{message}"
    puts
  end

  def print_error(message)
    puts
    puts "❌ Erro: #{message}"
    puts
  end

  def print_notice(message)
    puts
    puts "ℹ️ #{message}"
    puts
  end

  def exit_program
    @running = false

    puts "Encerrando. Até logo!"
  end
end
