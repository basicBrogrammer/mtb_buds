# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, except: :show
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all
  end

  def show
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, alert: 'Access denied.'
      end
    end
  end

  def update
    if @user.update(secure_params)
      redirect_to users_path, notice: 'User updated.'
    else
      redirect_to users_path, alert: 'Unable to update user.'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def admin_only
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end

  def secure_params
    params.require(:user).permit(:role)
  end
end
