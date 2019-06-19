# frozen_string_literal: true

module Users
  class SettingsController < ApplicationController
    layout false
    respond_to :js

    def update
      respond_to do |format|
        if current_user.setting.update(setting_params)
          message = I18n.t('settings.updated')
          format.html { redirect_to edit_user_registration_path, notice: message }
          format.json { render json: { message: message }, status: :created }
        else
          message = I18n.t('failed')
          format.html { redirect_to edit_user_registration_path, alert: message }
          format.json { render json: { message: message }, status: :unprocessable_entity }
        end
      end
    end

    private

    def setting_params
      params.require(:setting).permit(
        :comment_notifications,
        :ride_notifications,
        :participation_notifications
      )
    end
  end
end
