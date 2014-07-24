require 'rails_machine/configuration'

module RailsMachine
  extend ActiveSupport::Concern

  included do
    cattr_accessor :transitions

    validate :allowed_state, if: ->{ new_record? || state_changed? }
    private
    cattr_accessor :init_states
  end

  def allowed_state
    if self.new_record?
      validate_init_state
    else
      validate_transition
    end
  end

  def validate_init_state
    unless valid_init_state
      errors.add(:state,:invalid_init_state)
    end
  end

  def valid_init_state
    init_states.empty? || init_states.include?(self.state.to_sym)
  end

  def validate_transition
    from = self.state_was.to_sym
    to = self.state.to_sym

    transitions = (transitions_for(from) + transitions_for(:any)).select { |t| t[:to] == to || t[:to] == :any }
    return errors.add(:state, :transition_not_found) if transitions.empty?

    errors.add(:state, :guard_failed) if transitions.none? { |t| t[:guards].all? { |guard| guard.call(self) } }
  end

  module ClassMethods
    def rails_machine(column: :state, &blk)
      raise ArgumentError unless block_given?

      configuration = Configuration.new
      configuration.run(&blk)

      self.transitions = configuration.transitions
      self.init_states = configuration.init_states
      enum column => Hash[configuration.states]

      validates_presence_of column
    end
  end

  protected

  def transitions_for(action)
    self.class.transitions[action] || []
  end
end
