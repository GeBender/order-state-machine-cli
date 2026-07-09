# frozen_string_literal: true

class Order
  class InvalidTransitionError < StandardError; end

  INITIAL_STATE = :pending

  TRANSITIONS = {
    pending: %i[paid cancelled],
    paid: %i[shipped cancelled],
    shipped: %i[delivered],
    delivered: [],
    cancelled: []
  }.freeze

  attr_reader :id, :state, :history

  def initialize(id:)
    @id = id
    @state = INITIAL_STATE
    @history = [INITIAL_STATE]
  end

  def pay!
    transition_to(:paid)
  end

  def ship!
    transition_to(:shipped)
  end

  def deliver!
    transition_to(:delivered)
  end

  def cancel!
    transition_to(:cancelled)
  end

  private

  def transition_to(next_state)
    return apply_transition(next_state) if allowed_transition?(next_state)

    raise InvalidTransitionError, invalid_transition_message(next_state)
  end

  def allowed_transition?(next_state)
    TRANSITIONS.fetch(state).include?(next_state)
  end

  def apply_transition(next_state)
    @state = next_state
    @history << next_state

    self
  end

  def invalid_transition_message(next_state)
    allowed_states = TRANSITIONS.fetch(state)

    if allowed_states.empty?
      %(não é possível transicionar de "#{state}" para "#{next_state}". "#{state}" é um estado final.)
    else
      %(não é possível transicionar de "#{state}" para "#{next_state}". Transições permitidas: #{allowed_states.join(", ")}.)
    end
  end
end