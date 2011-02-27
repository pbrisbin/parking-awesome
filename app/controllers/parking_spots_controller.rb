class ParkingSpotsController < ApplicationController
  def index
    p = Parking.new(:address => params[:address], :heading => params[:heading], :latitude => params[:latitude], :longitude => params[:longitude], :evens=>params[:evens])
    if(p.valid?)
      render :json => p.to_json
    else
      render :json => p.to_json, :status => :unprocessable_entity      
    end
  end
  
  
end
