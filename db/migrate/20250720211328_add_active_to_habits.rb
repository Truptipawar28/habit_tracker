class AddActiveToHabits < ActiveRecord::Migration[8.0]
  def change
    add_column :habits, :active, :boolean
  end
end
