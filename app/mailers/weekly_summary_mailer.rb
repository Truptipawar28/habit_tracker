# app/mailers/weekly_summary_mailer.rb
class WeeklySummaryMailer < ApplicationMailer
  def summary_email(user)
    @user = user
    @habits = @user.habits.includes(:habit_checkins)  # <-- ADD THIS LINE
    mail(to: @user.email, subject: "Your Weekly Habit Summary")
  end
end
