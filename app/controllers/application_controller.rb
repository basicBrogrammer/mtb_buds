# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  respond_to :html

  protected

  # TEMP: redirect older users without location
  def check_location
    if request.path != edit_user_registration_path && current_user && current_user.location.nil?
      flash[:alert] = 'Please set your location to get notifications when other users post a ride near you.'
      redirect_to edit_user_registration_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name location])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar location])
  end
end
