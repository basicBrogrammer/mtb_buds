require 'rails_helper'

RSpec.describe Ride, type: :model do
  let!(:ride) { create(:ride) }
  let!(:old_ride) { create(:ride, day: 3.days.before) }

  it 'has a default scope of rides today or later' do
    expect(Ride.all).to contain_exactly ride
  end
end
