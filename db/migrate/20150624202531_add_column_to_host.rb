class AddColumnToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :address, :string
    add_reference :hosts, :province, index: true, foreign_key: true
    add_column :hosts, :country, :string
    add_column :hosts, :latitude, :float
    add_column :hosts, :longitude, :float

    add_column :hosts, :need_login, :boolean, default: false
    add_column :hosts, :parsed, :boolean, default: false

    add_column :hosts, :dev_comment, :text
    add_column :hosts, :cookie, :string
  end
end
