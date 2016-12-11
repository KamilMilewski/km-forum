# Defines forum category resource.
class Category < ApplicationRecord
  has_many :topics, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }

  # Calculates post count in this category.
  # Raw sql is used to leverage all load to db and max performance.
  def posts_count
    # Selects ids of topics belonging to this category.
    topic_ids = "SELECT id FROM topics
                 WHERE category_id = #{id}"
    # Black, dark magic but works with SQLite and PG.
    sql_query = "SELECT COUNT (*) FROM posts WHERE topic_id IN (#{topic_ids})"
    records_array = ActiveRecord::Base.connection.execute(sql_query)
    records_array[0].values.first
  end
end
