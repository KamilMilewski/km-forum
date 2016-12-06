# :nodoc:
class AddPictureToTopic < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :picture, :string
  end
end
