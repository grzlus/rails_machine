require 'spec_helper'

describe "Vehicle with RailsMachine" do

  describe "init state" do
    it do
      vehicle = Vehicle.new(state: :stopped)
      expect(vehicle).to be_valid
    end
    it do
      vehicle = Vehicle.new(state: :idling)
      expect(vehicle).not_to be_valid
    end
  end

  let(:vehicle) { Vehicle.create }

  it "starts as stopped" do
    expect(vehicle).to be_stopped
  end

  describe "strict transition" do

    it "allows switch to idling" do
      vehicle.idling!
      expect(vehicle).to be_idling
    end

    it "allows to switch from idle to driving and back" do
      vehicle.idling!
      vehicle.driving!
      vehicle.idling!
      expect(vehicle).to be_idling
    end

    it "doesn't allow to switch from stopped to driving" do
      expect{ vehicle.driving! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "loose transition (from any)" do

    before do
      vehicle.idling!
    end

    it "can be broken when idling" do
      vehicle.broken!
      expect(vehicle).to be_broken
    end

    it "can be broken when speeding" do
      vehicle.driving!
      vehicle.speeding!
      vehicle.broken!
      expect(vehicle).to be_broken
    end
  end

  describe "class attribute protection" do
    it "does not allow instance-level mutation of init_states" do
      expect { vehicle.init_states = [:driving] }.to raise_error(NoMethodError)
    end

    it "does not allow instance-level mutation of transitions" do
      expect { vehicle.transitions = {} }.to raise_error(NoMethodError)
    end

    it "freezes init_states so its contents cannot be mutated" do
      expect { Vehicle.init_states << :driving }.to raise_error(FrozenError)
    end

    it "freezes transitions so its contents cannot be mutated" do
      expect { Vehicle.transitions[:stopped] << { to: :speeding, guards: [] } }.to raise_error(FrozenError)
    end
  end

  describe "guards" do
    before { vehicle.idling!; vehicle.broken! }

    it "blocks a transition when the guard fails" do
      vehicle.inspected = false
      expect { vehicle.stopped! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "allows a transition when the guard passes" do
      vehicle.inspected = true
      vehicle.stopped!
      expect(vehicle).to be_stopped
    end

    it "adds a guard_failed error when blocked" do
      vehicle.inspected = false
      vehicle.state = :stopped
      vehicle.valid?
      expect(vehicle.errors[:state]).to include("transition was blocked by a guard")
    end
  end

  describe "error messages" do
    it "renders a human-readable message for invalid init state" do
      vehicle = Vehicle.new(state: :idling)
      vehicle.valid?
      expect(vehicle.errors[:state].first).not_to match(/Translation missing/)
    end

    it "renders a human-readable message for invalid transition" do
      vehicle.valid? # persisted, stopped
      vehicle.state = :driving
      vehicle.valid?
      expect(vehicle.errors[:state].first).not_to match(/Translation missing/)
    end
  end

  describe "missing configuration block" do
    it "raises with a descriptive message" do
      expect do
        Class.new(ActiveRecord::Base) do
          include RailsMachine
          rails_machine
        end
      end.to raise_error(ArgumentError, /requires a configuration block/)
    end
  end

  describe "duplicate state names" do
    it "raises on duplicate state definition" do
      expect do
        Class.new(ActiveRecord::Base) do
          include RailsMachine
          rails_machine do
            state :active
            state :active
          end
        end
      end.to raise_error(ArgumentError, /already defined/)
    end
  end

  describe "init_states" do
    it "doesn't allow bad state" do
      expect{ Vehicle.create!(state: :driving) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "does not crash when state is nil" do
      vehicle = Vehicle.new(state: nil)
      expect { vehicle.valid? }.not_to raise_error
    end

    it "is invalid when state is nil" do
      vehicle = Vehicle.new(state: nil)
      expect(vehicle).not_to be_valid
    end
  end
end
