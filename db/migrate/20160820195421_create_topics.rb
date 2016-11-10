class CreateTopics < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :topics do |t|
      t.string :title
      t.text :content
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end
