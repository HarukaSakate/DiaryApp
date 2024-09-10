class CreateDiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :diaries do |t|
      t.string :title
      t.text :body
      t.date :date
      t.string :tags

      t.timestamps
    end
  end
end
