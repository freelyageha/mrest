class AddColumnToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :parse_type, :integer, default: 1
  end
end
