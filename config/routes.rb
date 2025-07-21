require 'sidekiq/web' # ✅ Load Sidekiq web UI safely

Rails.application.routes.draw do
  # ✅ Mount Sidekiq dashboard
  mount Sidekiq::Web => '/sidekiq'

  # ✅ Devise routes for user authentication
  devise_for :users

  # ✅ Habits routes (full RESTful + nested check-ins)
resources :habits do
  post 'habit_checkins', to: 'habits#checkin_create', as: :checkins
end

  # ✅ Route for deleting a check-in (DELETE /habit_checkins/:id)
  delete 'habit_checkins/:id', to: 'habits#checkin_destroy', as: :habit_checkin

  # ✅ Root path (dashboard/homepage)
  root "habits#index"

  # ✅ Optional health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
end
