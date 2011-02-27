class ParkingSpotsController < ApplicationController
  def index
    render :json => Parking.new(:address => params[:address], :heading => params[:heading], :latitude => params[:latitude], :longitude => params[:longitude]).to_json
  end
end
