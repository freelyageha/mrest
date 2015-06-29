class AddColumnToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :address, :string
    add_reference :hosts, :province, index: true, foreign_key: true
    add_column :hosts, :country, :string
    add_column :hosts, :latitude, :float
    add_column :hosts, :longitude, :float
  end
end
