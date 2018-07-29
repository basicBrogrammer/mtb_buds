class NotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.unread.subject
  #
  def unread(user)
    @user = user
    @notifications_by_type = @user.notifications.unread.group_by do |note|
      [note.target_type, note.target.try(:status)]
    end
    mail to: @user.email, subject: "Bi-daily MTBGrouRides Check-in"
  end

  private 

  def type_text(type, status)
    case type
    when 'Participation'
      if status == 'accepted'
        'group rides'
      elsif status == 'pending'
        'interested riders'
      end
    else 
      type.downcase.pluralize
    end
  end
  helper_method :type_text
end
