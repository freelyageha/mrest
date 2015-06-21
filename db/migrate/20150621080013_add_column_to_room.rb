class AddColumnToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :guest, :integer, limit: 2
  end
end
