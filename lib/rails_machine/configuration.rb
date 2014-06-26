module RailsMachine
	class Configuration

		attr_reader :states, :transitions

		def initialize
			@states ||= []
			@transitions ||= {}
		end

		# Just runs code
		def run(&blk)
			self.instance_eval(&blk)
		end

		def state(name)
			@states << name
		end

		def transition(from: :any, to: :any, guards: [])
			(@transitions[from] ||= [])<< { to: to, guards: guards }	
		end
	end
end
