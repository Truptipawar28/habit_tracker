Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Habits routes
  resources :habits, except: [:show] do
    # POST /habits/:habit_id/habit_checkins
    post 'habit_checkins', to: 'habits#checkin_create', as: :checkins
  end

  # DELETE /habit_checkins/:id
  delete 'habit_checkins/:id', to: 'habits#checkin_destroy', as: :habit_checkin

  # Root path
  root "habits#index"

  # Optional: Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
