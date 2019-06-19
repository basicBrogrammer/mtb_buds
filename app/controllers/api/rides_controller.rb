# frozen_string_literal: true

module Api
  class RidesController < BaseController
    before_action :find_current_user_ride, only: %i[update destroy]
    def index
      rides = if location.present?
                Ride.active.near(location).page(page)
              else
                Ride.active.all.page(page)
              end
      render json: RideSerializer.new(rides, include: %i[trail user], meta: { total_pages: rides.total_pages })
    end

    def show
      ride = Ride.find(params[:id])
      render json: RideSerializer.new(ride, include: %i[trail user])
    end

    def create
      ride = current_user.rides.build(ride_params.merge(trail_id: trail_id))

      if ride.save
        render json: RideSerializer.new(ride, include: [:trail])
      else
        render json: ErrorSerializer.new(ride)
      end
    end

    def update
      if @ride.update(ride_params)
        render json: RideSerializer.new(@ride, include: [:trail])
      else
        render json: ErrorSerializer.new(@ride)
      end
    end

    def destroy
      @ride.destroy
    end

    private

    def find_current_user_ride
      @ride = current_user.rides.find(params[:id])
    end

    def ride_params
      params.require(:data).require(:attributes).permit(:day, :time)
    end

    def trail_id
      params
        .require(:data)
        .require(:relationships)
        .require(:trail)
        .require(:data)[:id]
    end

    def page
      params[:page]
    end

    def location
      params[:location]
    end
  end
end
