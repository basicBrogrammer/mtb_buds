# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'on_destroy_delete_notifications' do
  let(:target) { create(described_class.model_name.i18n_key) }

  it 'deletes associated notifications' do
    create(:notification, target: target)
    expect(Notification.count).to be > 0
    target.destroy
    expect(Notification.count).to eq 0
  end
end
