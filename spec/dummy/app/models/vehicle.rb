class Vehicle < ActiveRecord::Base
	include RailsMachine

	rails_machine do
		state :test
	end
end
