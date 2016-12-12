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

  # This parallels last_activity column in Topic model.
  def last_activity
    if topics.empty?
      # If there are no topics yet in thic category then:
      updated_at
    else
      # Otherwise last activity is newest topic in this category is returned.
      topics.first.last_activity
    end
  end

  # Returns newest topic in this category.
  def last_topic
    topics.first
  end

  # Returns newest post in this category. If there is no posts in this topic
  # then nil is returned.
  def last_post
    topics.first.posts.last
  end

  # Returns last resource - post or topic.
  def last_resource
    post = topics.first.posts.last
    post.nil? ? topics.first : post
  end
end
