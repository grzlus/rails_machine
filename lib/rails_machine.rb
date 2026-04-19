require 'rails_machine/configuration'

I18n.load_path << File.expand_path('../config/locales/rails_machine.en.yml', __dir__)

module RailsMachine
  extend ActiveSupport::Concern

  included do
    cattr_accessor :transitions, instance_writer: false
    cattr_accessor :init_states, instance_writer: false

    validate :validate_init_state, on: :create
    validate :validate_transition, on: :update, if: :state_changed?
  end

  def validate_init_state
    unless valid_init_state
      errors.add(:state,:invalid_init_state)
    end
  end

  def valid_init_state
    return true if self.state.nil?
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
      raise ArgumentError, "rails_machine requires a configuration block" unless block_given?

      configuration = Configuration.new
      configuration.run(&blk)

      self.transitions = configuration.transitions.transform_values(&:freeze).freeze
      self.init_states = configuration.init_states.freeze
      enum column, configuration.states

      validates_presence_of column
    end
  end

  protected

  def transitions_for(action)
    self.class.transitions[action] || []
  end
end
