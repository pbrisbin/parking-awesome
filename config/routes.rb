ParkingAwesome::Application.routes.draw do
  root :to => "parking_spots#index"
  
  resources :parking_spots, :only => :index
end
