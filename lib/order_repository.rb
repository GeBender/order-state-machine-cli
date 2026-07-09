# frozen_string_literal: true

require "order"

class OrderRepository
  class OrderNotFoundError < StandardError; end

  def initialize
    @orders = {}
    @next_id = 1
  end

  def create
    order = Order.new(id: @next_id)
    @orders[order.id] = order
    @next_id += 1

    order
  end

  def all
    @orders.values
  end

  def find(id)
    order = @orders[id]

    return order if order

    raise OrderNotFoundError, %(pedido ##{id} não encontrado.)
  end
end