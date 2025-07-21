class HabitCheckin < ApplicationRecord
  belongs_to :habit

  # Validations
  validates :checkin_date, presence: true, uniqueness: { scope: :habit_id }
  validate :checkin_date_not_in_future

  # Scopes
  scope :today, -> { where(checkin_date: Date.current) }
  scope :past_week, -> { where(checkin_date: 1.week.ago.to_date..Date.current) }
  scope :past_month, -> { where(checkin_date: 1.month.ago.to_date..Date.current) }
  scope :ordered, -> { order(checkin_date: :desc) }

  private

  def checkin_date_not_in_future
    if checkin_date.present? && checkin_date > Date.current
      errors.add(:checkin_date, "can't be in the future")
    end
  end
end
