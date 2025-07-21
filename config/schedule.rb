every 1.day, at: '7:00 am' do
  runner "DailyHabitReminderJob.perform_later"
end
