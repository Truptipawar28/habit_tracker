class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: [:edit, :update, :destroy]

  def index
    @habits = current_user.habits
  end

  def new
    @habit = current_user.habits.build
  end

  def create
    @habit = current_user.habits.build(habit_params)
    if @habit.save
      redirect_to habits_path, notice: "Habit created successfully!"
    else
      render :new
    end
  end

  def edit
    # @habit is already set by before_action
  end

  def update
    if @habit.update(habit_params)
      redirect_to habits_path, notice: "Habit updated!"
    else
      render :edit
    end
  end

  def destroy
    @habit.destroy
    redirect_to habits_path, notice: "Habit deleted!"
  end

  private

  def set_habit
    # Safely finds the habit for current_user or raises 404 if not found
    @habit = current_user.habits.find_by(id: params[:id])
    redirect_to habits_path, alert: "Habit not found." if @habit.nil?
  end

  def habit_params
    # Permit only allowed parameters
    params.require(:habit).permit(:name, :description, :frequency)
  end
end
