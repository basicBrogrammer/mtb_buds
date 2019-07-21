# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ride, type: :model do
  let!(:ride) { create(:ride) }
  let!(:old_ride) { create(:ride, day: 3.days.before) }

  it_behaves_like 'on_destroy_delete_notifications'

  it 'has an active scope of rides today or later' do
    expect(Ride.active).to contain_exactly ride
  end
end
