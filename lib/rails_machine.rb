require 'rails_machine/configuration'

module RailsMachine
	extend ActiveSupport::Concern

	module ClassMethods
		def rails_machine(&blk)
			raise ArgumentError unless block_given?

			configuration = Configuration.new
			configuration.run(&blk)

			enum state: configuration.states
		end
	end
end
