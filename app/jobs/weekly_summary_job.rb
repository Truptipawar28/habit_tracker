class WeeklySummaryJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      WeeklySummaryMailer.summary_email(user).deliver_now
    end
  end
end
