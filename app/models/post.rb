# Defines forum Post resource.
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :post_votes, dependent: :destroy

  # Newest posts are displayed on the bottom of the last page in topic show.
  default_scope -> { order(created_at: :asc) }

  # Every change to post is treated as a new activity for corresponding topic.
  after_save :update_topic_last_activity

  # Mounts PictureUploader on 'picture' column to allow images upload associated
  # with this model. Provided by carrierwave gem.
  mount_uploader :picture, PictureUploader
  validate :picture_size

  validates :content, presence: true

  # Returns page this post is on (on posts index page).
  def page
    count = topic.posts.count
    index = topic.posts.to_a.index(self) + 1

    per_page = KmForum::POSTS_PER_PAGE
    if count < per_page
      # If there are less posts than per_page limit then last page is first page
      # In such case we have to pass nil as a page because in other case we get
      # unexpected behavior.
      nil
    elsif (index % per_page).zero?
      index / per_page
    else
      index / per_page + 1
    end
  end

  # Returns full path to this post in topic (with page param and anchor).
  def full_path
    Rails.application.routes.url_helpers
         .topic_path(topic, page: page, anchor: anchor)
  end

  # Returns upvotes count this post has.
  def upvotes_count
    post_votes.where(value: 1).sum(:value)
  end

  # Returns downvotes count this post has.
  def downvotes_count
    post_votes.where(value: -1).sum(:value) * -1
  end

  private

  def update_topic_last_activity
    topic.update_column(:last_activity, updated_at)
  end
end
