ParkingAwesome::Application.routes.draw do
  
  resources :parking_spots, :only => :index
  resources :snow_emergency, :only => :index

end
