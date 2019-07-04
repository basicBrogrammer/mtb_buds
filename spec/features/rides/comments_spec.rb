# frozen_string_literal: true

feature 'Ride comments', :devise, :js do
  let!(:user) { FactoryBot.create(:user) }
  let!(:ride) { create(:ride, trail_id: '7019014') }
  let!(:comment) { create(:comment, ride: ride) }

  context 'participants' do
    context 'accepted' do
      before do
        create(:participation, :accepted, user: user, ride: ride)

        sign_in_as(user)
        visit ride_path(ride)
      end

      scenario 'can see comments' do
        expect(page).to have_css '.card--comments'
        expect(page).to have_content comment.body
      end
    end

    context 'pending' do
      before do
        create(:participation, :pending, user: user, ride: ride)

        sign_in_as(user)
        visit ride_path(ride)
      end

      scenario 'cannot see comments' do
        sign_in_as(user)
        visit ride_path(ride)

        expect(page).to_not have_css '.card--comments'
        expect(page).to_not have_content comment.body
      end
    end

    context 'rejected' do
      before do
        create(:participation, :rejected, user: user, ride: ride)

        sign_in_as(user)
        visit ride_path(ride)
      end

      scenario 'cannot see comments' do
        sign_in_as(user)
        visit ride_path(ride)

        expect(page).to_not have_css '.card--comments'
        expect(page).to_not have_content comment.body
      end
    end
  end

  context 'non-participant' do
    scenario 'cannot see comments' do
      sign_in_as(user)
      visit ride_path(ride)

      expect(page).to_not have_css '.card--comments'
      expect(page).to_not have_content comment.body
    end
  end
end
