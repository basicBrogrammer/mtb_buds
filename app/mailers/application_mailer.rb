# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@mtbgrouprides.com'
  layout 'mailer'
end
