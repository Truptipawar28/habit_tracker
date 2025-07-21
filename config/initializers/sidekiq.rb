require 'sidekiq-scheduler'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = File.expand_path('../../sidekiq.yml', __FILE__)
    if File.exist?(schedule_file)
      yaml = YAML.load_file(schedule_file)
      Sidekiq.schedule = yaml['schedule'] || yaml[:schedule]
      Sidekiq::Scheduler.reload_schedule!
    end

    # Load Sidekiq-Cron Jobs
    Sidekiq::Cron::Job.load_from_hash!({
      'weekly_summary' => {
        'cron' => '0 7 * * 1', # Every Monday at 10:00 AM
        'class' => 'WeeklySummaryJob'
      }
    })
  end
end
