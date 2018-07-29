describe User do
  subject { create(:user, email: 'user@example.com') }

  it { should respond_to(:email) }

  it "#email returns a string" do
    expect(subject.email).to match 'user@example.com'
  end

  describe '#rides' do
    let!(:ride) { create(:ride, user: subject) }
    let!(:old_ride) { create(:ride, user: subject, day: 3.days.before) }

    it 'will show all past and future rides' do
      expect(subject.rides.all).to contain_exactly ride, old_ride
    end

    it '#active will show only present and future rides' do
      expect(subject.rides.active.all).to contain_exactly ride
    end
  end

  describe '#participating_rides' do
    let(:ride) { create(:ride) }
    let(:old_ride) { create(:ride, day: 3.days.before) }

    before do 
      create(:participation, user: subject, ride: ride)
      create(:participation, user: subject, ride: old_ride)
    end

    it 'has a default scope of rides today or later' do
      expect(subject.participating_rides.all).to contain_exactly ride, old_ride
      expect(subject.participating_rides.active.all).to contain_exactly ride
    end
  end

  describe '#notifications' do
    let(:user) { create(:user) }
    let(:notifications) { create_list(:notification, 10, :comment_target, user: user) }
    before do 
      read_notifications = notifications.select.with_index do |_, index|
        index % 2 == 0
      end

      Notification.read!(read_notifications.map(&:id))
    end

    it 'should order them by read_at nil' do
      expected_not_read = user.notifications.slice(0, 5)
      expected_not_read.each do |not_read|
        expect(not_read.read_at).to be_nil
      end

      expected_read = user.notifications.slice(5, 5)
      expected_read.each do |read|
        expect(read.read_at).to_not be_nil
      end
    end
  end

  describe '.geocode' do 
    let(:user) { create(:user) }
    let(:expected_ip) { '24.9.64.99'}
    let(:another_ip) { '198.85.228.129'}
    it 'will update the users latitude and longitude after sign in ip changes' do 
      expect(user.current_sign_in_ip).to be_nil
      expect(user.ip_address).to be_blank
      expect(user.latitude).to be_nil
      expect(user.longitude).to be_nil

      user.update(current_sign_in_ip: expected_ip)
      expected_lat, expected_lon = Geocoder.search(expected_ip).first.data['loc'].split(',')

      expect(user.current_sign_in_ip).to eq IPAddr.new(expected_ip)
      expect(user.ip_address).to eq expected_ip
      expect(user.latitude).to eq expected_lat.to_f
      expect(user.longitude).to eq expected_lon.to_f

      user.update(current_sign_in_ip: another_ip)
      expected_lat, expected_lon = Geocoder.search(another_ip).first.data['loc'].split(',')

      expect(user.current_sign_in_ip).to eq IPAddr.new(another_ip)
      expect(user.ip_address).to eq another_ip
      expect(user.latitude).to eq expected_lat.to_f
      expect(user.longitude).to eq expected_lon.to_f
    end
  end
end
