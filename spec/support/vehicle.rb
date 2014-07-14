class Vehicle < ActiveRecord::Base
  include RailsMachine

  rails_machine do
    state :stopped
    state :idling
    state :driving
    state :speeding
    state :broken

    init_state :stopped

    transition from: :stopped, to: :idling
    transition from: :idling, to: :stopped

    transition from: :idling, to: :driving
    transition from: :driving, to: :idling

    transition from: :driving, to: :speeding
    transition from: :speeding, to: :driving

    transition from: :any, to: :broken
    transition from: :broken, to: :stopped
  end
end

