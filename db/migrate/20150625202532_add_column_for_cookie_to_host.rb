class AddColumnForCookieToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :need_login, :boolean, default: false
    add_column :hosts, :parsed, :boolean, default: false

    add_column :hosts, :dev_comment, :text
    add_column :hosts, :cookie, :string
  end
end
