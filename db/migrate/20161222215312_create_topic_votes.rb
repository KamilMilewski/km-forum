class CreateTopicVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :topic_votes do |t|

      t.references :user,  foreign_key: true
      t.references :topic, foreign_key: true
      t.integer :value
    end

    add_index :topic_votes, [:user_id, :topic_id], unique: true
  end

end
