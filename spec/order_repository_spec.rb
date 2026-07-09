# frozen_string_literal: true

require "order_repository"

RSpec.describe OrderRepository do
  describe "#create" do
    it "creates an order with sequential id" do
      repository = described_class.new

      first_order = repository.create
      second_order = repository.create

      expect(first_order.id).to eq(1)
      expect(second_order.id).to eq(2)
    end

    it "creates orders with pending state" do
      repository = described_class.new

      order = repository.create

      expect(order.state).to eq(:pending)
    end
  end

  describe "#all" do
    it "returns all created orders" do
      repository = described_class.new

      first_order = repository.create
      second_order = repository.create

      expect(repository.all).to eq([first_order, second_order])
    end

    it "returns an empty array when there are no orders" do
      repository = described_class.new

      expect(repository.all).to eq([])
    end
  end

  describe "#find" do
    it "returns an order by id" do
      repository = described_class.new
      order = repository.create

      expect(repository.find(order.id)).to eq(order)
    end

    it "raises an error when order does not exist" do
      repository = described_class.new

      expect { repository.find(999) }
        .to raise_error(OrderRepository::OrderNotFoundError, "pedido #999 não encontrado.")
    end
  end
end