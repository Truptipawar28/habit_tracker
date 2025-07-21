require 'sidekiq/web' # ✅ Now safe to load

Rails.application.routes.draw do
  # ✅ Mount Sidekiq web UI
  mount Sidekiq::Web => '/sidekiq'

  # Devise routes for user authentication
  devise_for :users

  # Habits routes
  resources :habits, except: [:show] do
    post 'habit_checkins', to: 'habits#checkin_create', as: :checkins
  end

  delete 'habit_checkins/:id', to: 'habits#checkin_destroy', as: :habit_checkin

  # Root path
  root "habits#index"

  # Optional: Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
