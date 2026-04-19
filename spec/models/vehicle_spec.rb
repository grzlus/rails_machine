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
