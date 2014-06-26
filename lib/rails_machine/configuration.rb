module RailsMachine
	class Configuration

		attr_reader :states

		# Just runs code
		def run(&blk)
			self.instance_eval(&blk)
		end

		def state(name)
			(@states ||= []) << name
		end
	end
end
