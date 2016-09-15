class AddRememberTokenDigestToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :remember_token_digest, :string
  end
end
