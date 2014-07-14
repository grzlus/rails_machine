module RailsMachine
  class Configuration

    attr_reader :states, :transitions, :init_states

    def initialize
      @states = []
      @init_states = []
      @transitions = Hash.new{|hash,key| hash[key] = [] }
    end

    # Just runs code
    def run(&blk)
      self.instance_eval(&blk)
    end

    def init_state(state)
      @init_states << state
    end

    def state(name, id: next_id)
      @states << [name, id]
    end

    def transition(from: :any, to: :any, guards: [])
      @transitions[from] << { to: to, guards: guards }
    end

    def next_id
      if @states.empty?
        0
      else
        @states.map(&:second).max.next
      end
    end
  end
end
