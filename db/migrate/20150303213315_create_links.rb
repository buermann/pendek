class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :url
      t.integer :clicks, default: 0
      t.timestamps
    end
    add_index :links, :url, unique: true
  end
end
