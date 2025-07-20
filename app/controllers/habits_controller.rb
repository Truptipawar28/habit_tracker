class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: [:edit, :update, :destroy]

  def index
    @habits = current_user.habits.includes(:habit_checkins)
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

  def edit; end

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

  # 🔹 HabitCheckinsController logic moved here:

  def checkin_create
    habit = current_user.habits.find(params[:habit_id])
    habit.habit_checkins.create(checkin_date: Date.today)
    redirect_to habits_path, notice: "Checked in!"
  end

  def checkin_destroy
    checkin = HabitCheckin.find(params[:id])
    if checkin.habit.user == current_user
      checkin.destroy
      redirect_to habits_path, notice: "Check-in removed!"
    else
      redirect_to habits_path, alert: "Unauthorized action."
    end
  end

  private

  def set_habit
    @habit = current_user.habits.find_by(id: params[:id])
    redirect_to habits_path, alert: "Habit not found." if @habit.nil?
  end

  def habit_params
    params.require(:habit).permit(:title, :description, :frequency)
  end
end
