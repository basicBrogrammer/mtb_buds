# frozen_string_literal: true

feature 'Participation show page', :devise, :js do
  let(:user) { FactoryBot.create(:user) }
  let(:owner) { FactoryBot.create(:user) }

  let!(:ride) { create(:ride, user: owner, trail_id: '7019014') }
  let!(:other_ride) { create(:ride, user: owner, trail_id: '7019014') }
  let!(:pending_participation) { create(:participation, :pending, ride: ride) }
  let!(:accepted_participation) { create(:participation, :accepted, ride: ride) }
  let!(:rejected_participation) { create(:participation, :rejected, ride: ride) }
  let!(:other_participation) { create(:participation, :accepted) }

  context 'owner' do
    before do
      sign_in_as(owner)
      visit ride_path(ride)

      expect(page).to have_content ride.trail['name']
    end

    scenario 'will see accepted participations' do
      open_riders_collapse
      within '.participants' do
        within '.collection-item', text: accepted_participation.user.name do
          expect(page).to have_content 'accepted'
          expect(page).to_not have_link 'Accept'
          expect(page).to_not have_link 'Reject'
        end
      end
    end

    scenario 'will see pending participations' do
      open_riders_collapse
      within '.participants' do
        within '.collection-item', text: pending_participation.user.name do
          expect(page).to have_content 'pending'
          expect(page).to have_button 'Accept'
          expect(page).to have_button 'Reject'
        end
      end
    end

    scenario 'will see rejected participations' do
      open_riders_collapse
      within '.participants' do
        within '.collection-item', text: rejected_participation.user.name do
          expect(page).to have_content 'rejected'
          expect(page).to_not have_link 'Accept'
          expect(page).to_not have_link 'Reject'
        end
      end
    end

    scenario 'will not see other rides participations' do
      open_riders_collapse
      within '.participants' do
        expect(page).to_not have_content other_participation.user.name
      end
    end
  end

  context 'user' do
    before do
      sign_in_as(user)
      visit ride_path(ride)

      expect(page).to have_content ride.trail['name']
    end

    scenario 'will see accepted participations' do
      open_riders_collapse
      within '.participants' do
        within '.collection-item', text: accepted_participation.user.name do
          expect(page).to have_content 'accepted'
          expect(page).to_not have_button 'Accept'
          expect(page).to_not have_button 'Reject'
        end
      end
    end

    scenario 'will not see pending participations' do
      open_riders_collapse
      within '.participants' do
        expect(page).to_not have_content pending_participation.user.name
      end
    end

    scenario 'will not see rejected participations' do
      open_riders_collapse
      within '.participants' do
        expect(page).to_not have_content rejected_participation.user.name
      end
    end

    scenario 'will not see other rides participations' do
      open_riders_collapse
      within '.participants' do
        expect(page).to_not have_content other_participation.user.name
      end
    end
  end

  context 'ride time visibility' do
    scenario 'ride time will not be visible to a user that has not requested to join' do
      expect(user.participating_rides).to be_empty
      sign_in_as(user)
      visit ride_path(ride)

      expect(page).to have_content ride.trail['name']
      within '.ride__time' do
        expect(page).to have_content ride.pretty_day
        expect(page).to_not have_content ride.pretty_time
      end
    end

    scenario 'ride time will not be visible to a pending participant' do
      create(:participation, :pending, ride: ride, user: user)

      sign_in_as(user)
      visit ride_path(ride)

      expect(page).to have_content ride.trail['name']
      within '.ride__time' do
        expect(page).to have_content ride.pretty_day
        expect(page).to_not have_content ride.pretty_time
      end
    end

    scenario 'ride time will not be visible to a rejected participant' do
      create(:participation, :rejected, ride: ride, user: user)

      sign_in_as(user)
      visit ride_path(ride)

      expect(page).to have_content ride.trail['name']
      within '.ride__time' do
        expect(page).to have_content ride.pretty_day
        expect(page).to_not have_content ride.pretty_time
      end
    end

    scenario 'ride time will be visible to a accepted participant' do
      create(:participation, :accepted, ride: ride, user: user)

      sign_in_as(user)
      visit ride_path(ride)

      expect(page).to have_content ride.trail['name']
      within '.ride__time' do
        expect(page).to have_content ride.pretty_day
        expect(page).to have_content ride.pretty_time
      end
    end
  end
end
