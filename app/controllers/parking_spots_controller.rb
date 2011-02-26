class ParkingSpotsController < ApplicationController
  def index
    render :json => Parking.new(:address => params[:address], :heading => params[:heading]).to_json
  end
end
