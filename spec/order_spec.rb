# frozen_string_literal: true

require "order"

RSpec.describe Order do
  describe "#initialize" do
    it "starts with pending state" do
      order = described_class.new(id: 1)

      expect(order.id).to eq(1)
      expect(order.state).to eq(:pending)
    end

    it "starts history with pending state" do
      order = described_class.new(id: 1)

      expect(order.history).to eq(%i[pending])
    end
  end

  describe "valid transitions" do
    it "transitions from pending to paid" do
      order = described_class.new(id: 1)

      order.pay!

      expect(order.state).to eq(:paid)
      expect(order.history).to eq(%i[pending paid])
    end

    it "transitions from paid to shipped" do
      order = described_class.new(id: 1)

      order.pay!
      order.ship!

      expect(order.state).to eq(:shipped)
      expect(order.history).to eq(%i[pending paid shipped])
    end

    it "transitions from shipped to delivered" do
      order = described_class.new(id: 1)

      order.pay!
      order.ship!
      order.deliver!

      expect(order.state).to eq(:delivered)
      expect(order.history).to eq(%i[pending paid shipped delivered])
    end

    it "transitions from pending to cancelled" do
      order = described_class.new(id: 1)

      order.cancel!

      expect(order.state).to eq(:cancelled)
      expect(order.history).to eq(%i[pending cancelled])
    end

    it "transitions from paid to cancelled" do
      order = described_class.new(id: 1)

      order.pay!
      order.cancel!

      expect(order.state).to eq(:cancelled)
      expect(order.history).to eq(%i[pending paid cancelled])
    end
  end

  describe "invalid transitions" do
    it "does not transition directly from pending to shipped" do
      order = described_class.new(id: 1)

      expect { order.ship! }
        .to raise_error(Order::InvalidTransitionError, /pending.*shipped/)

      expect(order.state).to eq(:pending)
      expect(order.history).to eq(%i[pending])
    end

    it "does not transition directly from pending to delivered" do
      order = described_class.new(id: 1)

      expect { order.deliver! }
        .to raise_error(Order::InvalidTransitionError, /pending.*delivered/)

      expect(order.state).to eq(:pending)
      expect(order.history).to eq(%i[pending])
    end

    it "does not transition from delivered to another state" do
      order = described_class.new(id: 1)

      order.pay!
      order.ship!
      order.deliver!

      expect { order.cancel! }
        .to raise_error(Order::InvalidTransitionError, /delivered.*cancelled/)

      expect(order.state).to eq(:delivered)
      expect(order.history).to eq(%i[pending paid shipped delivered])
    end

    it "does not transition from cancelled to another state" do
      order = described_class.new(id: 1)

      order.cancel!

      expect { order.pay! }
        .to raise_error(Order::InvalidTransitionError, /cancelled.*paid/)

      expect(order.state).to eq(:cancelled)
      expect(order.history).to eq(%i[pending cancelled])
    end
  end
end