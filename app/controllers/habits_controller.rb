class HabitsController < ApplicationController
  before_action :authenticate_user!
before_action :set_habit, only: [:show, :edit, :update, :destroy]
 


def index
    @habits = current_user.habits.includes(:habit_checkins)
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

  def edit
    # @habit is already set via before_action
  end

  def update
    if @habit.update(habit_params)
      redirect_to habits_path, notice: "Habit updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @habit.destroy
    redirect_to habits_path, notice: "Habit deleted successfully."
  end

def checkin_create
  habit = current_user.habits.find(params[:habit_id])
  date = params[:checkin_date]

  if date.blank?
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.prepend("flash", partial: "shared/flash", locals: { notice: nil, alert: "Check-in date is missing." }) }
      format.html { redirect_to habits_path, alert: "Check-in date is missing." }
    end
  else
    habit.habit_checkins.find_or_create_by!(checkin_date: date)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("habit_stats_#{habit.id}", partial: "habits/stats", locals: { habit: habit }),
          turbo_stream.prepend("flash", partial: "shared/flash", locals: { notice: "Marked as done!", alert: nil })
        ]
      end
      format.html { redirect_to habits_path, notice: "Marked as done!" }
    end
  end
end



  def checkin_destroy
    checkin = HabitCheckin.find(params[:id])
    checkin.destroy
    redirect_to habits_path, notice: "Check-in removed."
  end

  def show
  @chart_data = @habit.checkins_by_day
end

  private

  def set_habit
    @habit = current_user.habits.find_by(id: params[:id])
    redirect_to habits_path, alert: "Habit not found." unless @habit
  end

  def habit_params
    params.require(:habit).permit(:title, :description, :start_date)
  end
end
