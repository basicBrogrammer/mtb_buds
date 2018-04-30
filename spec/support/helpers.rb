require 'support/helpers/session_helpers'
require 'support/helpers/confirm_dialog_helper'
require 'support/helpers/select2_helpers'
require 'support/helpers/ride_helpers'
require 'support/helpers/materialize_helpers'

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::ConfirmDialogHelper, type: :feature
  config.include Features::Select2Helpers, type: :feature
  config.include Features::RideHelpers, type: :feature
  config.include Features::MaterializeHelpers, type: :feature
end
