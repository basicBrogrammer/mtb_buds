class RidesController < ApplicationController
  before_action :set_ride, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: :index

  def index
  end

  def show
    if current_user == @ride.user
      @participations = @ride.participations.includes(:user)
    else
      @participations = @ride.participations.accepted.includes(:user)
    end
  end

  def new
    @ride = Ride.new
  end

  def edit
  end

  def create
    # TODO: servicitize controllers?
    @ride = current_user.rides.build(ride_params)

    respond_to do |format|
      if @ride.save
        format.html { redirect_to @ride, notice: I18n.t('rides.created') }
        format.json { render :show, status: :created, location: @ride }
      else
        format.html { render :new }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO: do we need update?
  def update
    respond_to do |format|
      if @ride.update(ride_params)
        format.html { redirect_to @ride, notice: I18n.t('rides.updated') }
        format.json { render :show, status: :ok, location: @ride }
      else
        format.html { render :edit }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rides/1
  # DELETE /rides/1.json
  def destroy
    @ride.destroy
    respond_to do |format|
      format.html { redirect_to rides_url, notice: 'Ride was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ride
      @ride = Ride.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ride_params
      params.fetch(:ride).permit(:trail_id, :day, :time)
    end

    def correct_user
      if @ride.user != current_user
        redirect_to root_path, alert: I18n.t('unauthorized')
      end
    end
end
