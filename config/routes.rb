Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Nested routes for habit check-ins
  resources :habits do
    resources :habit_checkins, only: [:create]
  end

  # Separate route to delete a check-in
  resources :habit_checkins, only: [:destroy]

  # Root path goes to habit list
  root "habits#index"

  # Health check route (optional, for uptime monitoring)
  get "up" => "rails/health#show", as: :rails_health_check
end
