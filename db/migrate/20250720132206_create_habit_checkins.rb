class CreateHabitCheckins < ActiveRecord::Migration[8.0]
  def change
    create_table :habit_checkins do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :checkin_date

      t.timestamps
    end
  end
end