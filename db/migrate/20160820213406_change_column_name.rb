class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :users, :type, :permissions
  end
end
