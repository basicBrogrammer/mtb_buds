# frozen_string_literal: true

class Api::UsersController < Devise::RegistrationsController
  before_action :doorkeeper_authorize!, only: :me
  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      expire_data_after_sign_in! unless resource.active_for_authentication?
      render json: UserSerializer.new(resource) # , location: after_inactive_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length

      render json: { errors: ErrorSerializer.new(resource).serialized_json }, status: :unprocessable_entity
    end
  end

  def me
    api_user = User.find(doorkeeper_token&.resource_owner_id)
    render json: UserSerializer.new(api_user)
  end

  private

  def sign_up_params
    params.require(:data).require(:attributes).permit(:name, :email, :password)
  end
end
