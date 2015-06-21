class AddColumnsToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :size, :integer, limit: 2
    add_column :rooms, :price, :integer
    add_column :rooms, :dicounted_price, :integer
  end
end
