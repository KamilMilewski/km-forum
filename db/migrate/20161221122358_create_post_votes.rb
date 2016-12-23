class CreatePostVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :post_votes do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.integer :vote

      t.timestamps
    end
  end
end
