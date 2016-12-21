# User should be able to vote on given post only once.
class AddUniquenessOnPostIdUserIdPair < ActiveRecord::Migration[5.0]
  def change
    add_index :post_votes, [:user_id, :post_id], unique: true
  end
end
