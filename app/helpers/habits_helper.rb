module HabitsHelper
  def calendar_days(year, month)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    # Build an array of all days including blanks at the beginning
    (start_date.beginning_of_week(:sunday)..end_date.end_of_week(:sunday)).to_a
  end
end
