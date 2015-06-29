class AddColumnUniqIdToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :uniq_id, :integer
  end
end
