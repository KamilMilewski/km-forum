class ChangeColumnNameInPostVotes < ActiveRecord::Migration[5.0]
  def change
    rename_column :post_votes, :vote, :value
  end
end
