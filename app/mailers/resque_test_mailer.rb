class ResqueTestMailer < ApplicationMailer
  def testing(user)
    mail(to: user.email, subject: 'Welcome to My Awesome Site')
  end
end
