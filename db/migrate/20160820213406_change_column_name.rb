class ChangeColumnName < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    rename_column :users, :type, :permissions
  end
end
