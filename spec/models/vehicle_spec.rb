require 'spec_helper'

describe "Vehicle with RailsMachine" do

  let(:vehicle) { Vehicle.new }

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

    it "can be broken when idling" do
      vehicle = Vehicle.new(state: :idling)
      vehicle.broken!
      expect(vehicle).to be_broken
    end

    it "can be broken when speeding" do
      vehicle = Vehicle.new(state: :speeding)
      vehicle.broken!
      expect(vehicle).to be_broken
    end
  end
end
