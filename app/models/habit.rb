class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checkins, dependent: :destroy

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }

  # Scopes for common queries
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :with_checkins_for_date, ->(date) { includes(:habit_checkins).where(habit_checkins: { checkin_date: date }) }
  scope :completed_today, -> { with_checkins_for_date(Date.current) }
  scope :pending_today, -> { where.not(id: completed_today) }

  # Current streak (consecutive days up to today)
  def current_streak
    streak = 0
    date   = Date.current
    while habit_checkins.exists?(checkin_date: date)
      streak += 1
      date -= 1.day
    end
    streak
  end

  # Longest streak ever
  def longest_streak
    dates = habit_checkins.order(:checkin_date).pluck(:checkin_date)
    return 0 if dates.empty?

    max, curr = 1, 1
    dates.each_cons(2) do |y, t|
      if t == y + 1.day
        curr += 1
        max  = [max, curr].max
      else
        curr = 1
      end
    end
    max
  end

  # Consistency %
  def completion_rate
    total_days     = (Date.current - created_at.to_date).to_i + 1
    completed_days = habit_checkins.count
    ((completed_days.to_f / total_days) * 100).round(2)
  end

  def completed_today?
    habit_checkins.exists?(checkin_date: Date.current)
  end
end
