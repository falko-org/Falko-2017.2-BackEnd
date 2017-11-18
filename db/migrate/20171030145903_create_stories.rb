class CreateStories < ActiveRecord::Migration[5.1]
  def change
    create_table :stories do |t|
      t.string :name
      t.text :description
      t.string :assign
      t.string :pipeline

      t.timestamps
    end
  end
end
