class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checkins, dependent: :destroy

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :with_checkins_for_date, ->(date) { includes(:habit_checkins).where(habit_checkins: { checkin_date: date }) }
  scope :completed_today, -> { with_checkins_for_date(Date.current) }
  scope :pending_today, -> { where.not(id: completed_today) }

  # ✅ 1. Current Streak (up to today)
  def current_streak
    return 0 if habit_checkins.empty?

    streak = 0
    date = Date.current

    while habit_checkins.exists?(checkin_date: date)
      streak += 1
      date -= 1.day
    end

    streak
  end

  # ✅ 2. Longest Streak (historically)
  def longest_streak
    dates = habit_checkins.order(:checkin_date).pluck(:checkin_date).uniq
    return 0 if dates.empty?

    max = curr = 1
    dates.each_cons(2) do |prev, curr_date|
      if curr_date == prev + 1.day
        curr += 1
        max = [max, curr].max
      else
        curr = 1
      end
    end

    max
  end

  # ✅ 3. Consistency (updated to only count scheduled days)
def consistency
  return 0.0 if start_date.blank?

  today = Date.current
  total_scheduled_days = (start_date..today).count do |date|
    scheduled_on_day?(date)
  end

  return 0.0 if total_scheduled_days.zero?

  completed_days = habit_checkins.where(checkin_date: start_date..today).distinct.count(:checkin_date)

  (completed_days.to_f / total_scheduled_days * 100).round(1)
end


def completion_rate
  start = start_date || created_at.to_date
  total_days     = (Date.current - start).to_i + 1
  completed_days = habit_checkins.distinct.count(:checkin_date)
  percentage     = (completed_days.to_f / total_days) * 100

  Rails.logger.info "DEBUG: start=#{start}, total_days=#{total_days}, completed_days=#{completed_days}, percentage=#{percentage}"

  [percentage, 100].min.round(2)
end



  # ✅ 4. Checks if the habit is scheduled on the given date
  def scheduled_on_day?(date)
    scheduled_day = title.downcase[/sunday|monday|tuesday|wednesday|thursday|friday|saturday/]
    return true unless scheduled_day # fallback for habits without a weekday in title
    date.strftime("%A").downcase == scheduled_day
  end

  # ✅ 5. Checked-in today?
  def checked_in_today?
    habit_checkins.exists?(checkin_date: Date.current)
  end

  # ✅ 6. For calendar graph
  def checkins_by_day
    habit_checkins.group_by_day(:checkin_date, last: 30).count
  end
end
