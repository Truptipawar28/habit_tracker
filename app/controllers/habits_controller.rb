class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: [:show, :edit, :update, :destroy]

  def index
    @habits = current_user.habits.includes(:habit_checkins)
  end

def show
  @habit = current_user.habits.find(params[:id])
  checkins = @habit.habit_checkins.group(:checkin_date).count
  @chart_data = checkins.sort.to_h
end


  def new
    @habit = current_user.habits.build
  end

  def create
    @habit = current_user.habits.build(habit_params)
    if @habit.save
      redirect_to habits_path, notice: "Habit was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @habit.update(habit_params)
      redirect_to habits_path, notice: "Habit updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @habit.destroy
    redirect_to habits_path, notice: "Habit deleted."
  end

  def checkin_create
    habit = current_user.habits.find(params[:habit_id])
    date = params[:checkin_date]

    if date.blank?
      redirect_to habits_path, alert: "Check-in date is missing."
    else
      habit.habit_checkins.find_or_create_by!(checkin_date: date)
      redirect_to habits_path, notice: "Marked as done!"
    end
  end

  def checkin_destroy
    checkin = HabitCheckin.find_by(id: params[:id])
    if checkin&.habit&.user == current_user
      checkin.destroy
      redirect_to habits_path, notice: "Check-in removed!"
    else
      redirect_to habits_path, alert: "Unauthorized action or check-in not found."
    end
  end



  private

  def set_habit
    @habit = current_user.habits.find_by(id: params[:id])
    redirect_to habits_path, alert: "Habit not found." unless @habit
  end

  def habit_params
    params.require(:habit).permit(:title, :description)
  end
end
