Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # RESTful routes for habits
  resources :habits

  # Root path goes to welcome#index
  root "habits#index"


  # Health check route (optional, for uptime monitoring)
  get "up" => "rails/health#show", as: :rails_health_check

  # (Optional) Uncomment these if you're adding PWA support later
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
