class CreateHabitCheckins < ActiveRecord::Migration[7.0]
  def change
    create_table :habit_checkins do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :checkin_date, null: false

      t.timestamps
    end

    add_index :habit_checkins, [:habit_id, :checkin_date], unique: true
  end
end
