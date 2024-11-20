class CreateMemories < ActiveRecord::Migration[6.1]
  def change
    create_table :memories do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.date :memory_date
      t.integer :feeling

      t.timestamps
    end
  end
end
