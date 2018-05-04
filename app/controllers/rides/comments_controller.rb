# frozen_string_literal: true

module Rides
  class CommentsController < ApplicationController
    layout false
    def index
      store_location_for(:user, rides_path)
      @comments = Comment.where(ride_id: params[:ride_id]) 
    end
  end
end
