class AddColumnToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :host_id, :integer
  end
end
