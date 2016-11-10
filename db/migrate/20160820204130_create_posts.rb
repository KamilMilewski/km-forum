class CreatePosts < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :posts do |t|
      t.text :content
      t.belongs_to :topic, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
