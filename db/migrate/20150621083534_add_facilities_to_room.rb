class AddFacilitiesToRoom < ActiveRecord::Migration
  def change
    remove_column :rooms, :dicounted_price, :integer

    add_column :rooms, :facilities, :string
    add_column :rooms, :discounted_price, :integer
  end
end
