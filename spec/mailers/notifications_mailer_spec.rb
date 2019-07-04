# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsMailer, type: :mailer do
  describe 'unread' do
    let(:user) { create(:user) }
    let(:mail) { NotificationsMailer.unread(user) }
    let(:ride) { create(:ride, user: user) }
    let(:comment) { create(:comment, ride: ride) }
    let(:pending_participation) { create(:participation, :pending, ride: ride) }
    let(:accepted_participation) { create(:participation, :accepted, user: user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Bi-daily MTBGrouRides Check-in')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['info@mtbgrouprides.com'])
    end

    context 'with all types of comments' do
      before do
        perform_enqueued_jobs do
          # create notifications
          comment
          pending_participation
          accepted_participation.accepted!
        end
      end

      it 'renders the body' do
        expect(mail.body.encoded).to match(
          '<p>You have 1 new <a href="http://example.com/notifications">comments</a></p'
        )
        expect(mail.body.encoded).to match(
          '<p>You have 1 new <a href="http://example.com/notifications">interested riders</a></p'
        )
        expect(mail.body.encoded).to match(
          '<p>You have 1 new <a href="http://example.com/notifications">group rides</a></p'
        )
      end
    end

    context 'with only comments' do
      before do 
        perform_enqueued_jobs do
          # create notifications
          comment
        end
      end

      it 'renders the body' do
        expect(mail.body.encoded).to match(
          '<p>You have 1 new <a href="http://example.com/notifications">comments</a></p'
        )
        expect(mail.body.encoded).to_not match(
          '<p>You have 1 new <a href="http://example.com/notifications">interested riders</a></p'
        )
        expect(mail.body.encoded).to_not match(
          '<p>You have 1 new <a href="http://example.com/notifications">group rides</a></p'
        )
      end
    end

    context 'with only interested riders' do
      before do
        perform_enqueued_jobs do
          # create notifications
          pending_participation
        end
      end

      it 'renders the body' do
        expect(mail.body.encoded).to_not match(
          '<p>You have 1 new <a href="http://example.com/notifications">comments</a></p'
        )
        expect(mail.body.encoded).to match(
          '<p>You have 1 new <a href="http://example.com/notifications">interested riders</a></p'
        )
        expect(mail.body.encoded).to_not match(
          '<p>You have 1 new <a href="http://example.com/notifications">group rides</a></p'
        )
      end
    end

    context 'with only accepted participation' do
      before do
        perform_enqueued_jobs do
          # create notifications
          accepted_participation.accepted!
        end
      end

      it 'renders the body' do
        expect(mail.body.encoded).to_not match(
          '<p>You have 1 new <a href="http://example.com/notifications">comments</a></p'
        )
        expect(mail.body.encoded).to_not match(
          '<p>You have 1 new <a href="http://example.com/notifications">interested riders</a></p'
        )
        expect(mail.body.encoded).to match(
          '<p>You have 1 new <a href="http://example.com/notifications">group rides</a></p'
        )
      end
    end
  end
end
