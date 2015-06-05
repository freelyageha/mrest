class AddColumnToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :year, :integer
  end
end
