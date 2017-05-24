Rails.application.routes.draw do
  resources :sessions
  resources :stations
  root  "static#index"
  get 'nowpresent' => 'stations#nowpresent'
  get 'anyone_here' => 'stations#anyone_here?'
  get 'timeline' => 'sessions#timeline'
  get 'today' => 'static#today'
end
