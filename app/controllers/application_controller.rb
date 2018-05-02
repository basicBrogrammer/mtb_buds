class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def mobile?
    browser.device.mobile?
  end
  helper_method :mobile?

  def nav_active?(nav_path)
    if request.path == rides_path && nav_path == root_path
      nav_path = rides_path
    end
    request.path == nav_path ? 'active' : ''
  end
  helper_method :nav_active?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end
end
