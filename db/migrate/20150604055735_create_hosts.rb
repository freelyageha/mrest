class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :name
      t.string :url
      t.string :parse_url
      t.string :reserve_url

      t.timestamps null: false
    end
  end
end
