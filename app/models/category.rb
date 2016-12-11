# Defines forum category resource.
class Category < ApplicationRecord
  has_many :topics, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }

  # Calculates post count in this category.
  # Raw sql is used to leverage all load to db and max performance.
  def posts_count
    topic_ids = "SELECT id FROM topics
                 WHERE category_id = #{id}"
    sql_query = "SELECT COUNT (*) FROM posts WHERE topic_id IN (#{topic_ids})"
    records_array = ActiveRecord::Base.connection.execute(sql_query)
  end
end
