# :nodoc:
class AddDefaultValueToPermissionsAttribute < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :permissions, from: '', to: 'user'
  end
end
