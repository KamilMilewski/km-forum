# :nodoc:
class AddPasswordResetToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_reset_token_digest, :string
    add_column :users, :sent_reset_at, :datetime
  end
end
