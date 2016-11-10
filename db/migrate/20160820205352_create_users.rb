class CreateUsers < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :type

      t.timestamps
    end
  end
end
