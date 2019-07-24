# frozen_string_literal: true

feature 'Visitors and Users can search rides', :devise, :js do
  let!(:boulder_ride) { create(:ride, :boulder) }
  let!(:moab_ride) { create(:ride, :moab) }
  let(:user) { create(:user) }

  scenario 'by location' do
    sign_in_as(user)
    visit rides_path
    expect(page).to have_content boulder_ride.name
    expect(page).to have_content moab_ride.name

    select2_search('Bou', choice: 'Boulder, CO, USA', from: '.location-filter')

    expect(page).to have_content boulder_ride.name
    expect(page).to_not have_content moab_ride.name
    expect(find('#select2-location-container').text).to eq 'Boulder, CO, USA'
  end
end
