class Vehicle < ActiveRecord::Base
	include RailsMachine

	rails_machine do
		state :test
		state :another

		transition to: :another
		transition from: :another
	end
end
