class Vehicle < ActiveRecord::Base
	include RailsMachine

	rails_machine do
		state :test
		state :another
	end
end
