class AddStartDateToHabits < ActiveRecord::Migration[8.0]
  def change
    add_column :habits, :start_date, :date
  end
end
