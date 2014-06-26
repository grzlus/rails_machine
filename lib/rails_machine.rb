require 'rails_machine/configuration'

module RailsMachine
	extend ActiveSupport::Concern

	included do
		validate :allowed_transition, if: :state_changed?
	end

	def allowed_transition
		from = self.state_was.to_sym
		to = self.state.to_sym

		transitions = transitions_for(from, to)
		errors.add(:state, :transition_not_found) if transitions.empty?

		errors.add(:state, :guard_failed) if transitions.none? { |t| t[:guards].all? { |guard| guard.call(self) } }
	end

	module ClassMethods
		def rails_machine(&blk)
			raise ArgumentError unless block_given?

			configuration = Configuration.new
			configuration.run(&blk)

			enum state: configuration.states
		end
	end

	protected

	def transitions_for(from, to)
		[]	
	end
end
