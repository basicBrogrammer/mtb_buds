# frozen_string_literal: true

module Api
  class ConfirmationsController < BaseController
    skip_before_action :doorkeeper_authorize!
    def create
      resource = User.confirm_by_token(confirmation_token)
      yield resource if block_given?

      if resource.errors.empty?
        render json: UserSerializer.new(resource)
      else
        # respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
        render json: { errors: ErrorSerializer.new(resource).serialized_json }, status: :unprocessable_entity
      end
    end

    private

    def confirmation_token
      params.require(:data).require(:attributes).permit(:token)[:token]
    end
  end
end
