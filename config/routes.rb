ParkingAwesome::Application.routes.draw do
  
  resources :parking_spots, :only => :index
end
