class ParkingSpotsController < ApplicationController
  def index
    #TODO fill in with real data
    render :json => {:success => true, :address => '302 Newbury Street, Boston MA', :left => {:flag => 'meter', :message => 'until 8pm'}, :right => {:flag => 'ok'}}.to_json
  end
end
