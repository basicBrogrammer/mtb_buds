# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'on_destroy_delete_notifications'
end
