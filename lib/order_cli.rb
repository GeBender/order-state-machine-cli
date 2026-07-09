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
    puts "1. Criar pedido"
    puts "2. Listar pedidos"
    puts "3. Consultar pedido"
    puts "4. Pagar pedido"
    puts "5. Enviar pedido"
    puts "6. Entregar pedido"
    puts "7. Cancelar pedido"
    puts "8. Sair"
    print "Escolha uma opção: "
  end

  def read_option
    gets&.strip
  end

  def handle_option(option)
    case option
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
      puts "Erro: opção inválida. Escolha uma opção entre 1 e 8."
    end
  end

  def create_order
    order = repository.create

    puts "Pedido ##{order.id} criado com sucesso. Estado: #{order.state}"
  end

  def list_orders
    orders = repository.all

    if orders.empty?
      puts "Nenhum pedido criado."
      return
    end

    orders.each do |order|
      puts "##{order.id} - #{order.state}"
    end
  end

  def show_order
    order = find_order_from_input

    return unless order

    puts "Pedido ##{order.id} — Estado atual: #{order.state}"
    puts "Histórico: #{order.history.join(' -> ')}"
  end

  def transition_order(action, success_description)
    order = find_order_from_input

    return unless order

    order.public_send(action)

    puts "Pedido ##{order.id} #{success_description} com sucesso. Estado: #{order.state}"
  rescue Order::InvalidTransitionError => error
    puts "Erro: #{error.message}"
  end

  def find_order_from_input
    id = read_order_id

    return unless id

    repository.find(id)
  rescue OrderRepository::OrderNotFoundError => error
    puts "Erro: #{error.message}"
    nil
  end

  def read_order_id
    print "Informe o número do pedido: "

    input = gets&.strip

    unless valid_integer?(input)
      puts "Erro: informe um número de pedido válido."
      return nil
    end

    input.to_i
  end

  def valid_integer?(input)
    input&.match?(/\A\d+\z/)
  end

  def exit_program
    @running = false

    puts "Encerrando. Até logo!"
  end
end