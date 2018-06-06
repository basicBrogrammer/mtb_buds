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
end
