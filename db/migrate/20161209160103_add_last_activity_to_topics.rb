# :nodoc:
class AddLastActivityToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :last_activity, :datetime
  end
end
