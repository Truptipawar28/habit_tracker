class HabitCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info("✅ Running HabitCleanupJob at #{Time.current}")
    
    # Find all users and send them the summary email
    User.find_each do |user|
      WeeklySummaryMailer.summary_email(user).deliver_now
    end
  end
end
