class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :year
      t.integer :month
      t.integer :day
      t.boolean :reserved, default: false
      t.references :host, index: true
      t.references :room, index: true

      t.timestamps null: false
    end
  end
end
