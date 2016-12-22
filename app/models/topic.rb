# Defines forum topic resource.
class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy
  belongs_to :user
  belongs_to :category
  has_many :topic_votes, dependent: :destroy

  # Newest topics are on top of the page.
  default_scope -> { order(last_activity: :desc) }

  # Every change to topic itself is treated as a new activity. Besides that
  # every change to posts in this topic (create or update) is new activity too.
  after_save :update_last_activity

  # Mounts PictureUploader on 'picture' column to allow images upload associated
  # with this model. Provided by carrierwave gem.
  mount_uploader :picture, PictureUploader
  validate :picture_size

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true

  # Returns last page number.
  def last_page
    count = posts.count
    per_page = KmForum::POSTS_PER_PAGE
    if count < per_page
      # If there are less posts than per_page limit then last page is first page
      # In such case we have to pass nil as a page because in other case we get
      # unexpected behavior.
      nil
    elsif (count % per_page).zero?
      count / per_page
    else
      count / per_page + 1
    end
  end

  # Returns upvotes count this topic has.
  def upvotes_count
    topic_votes.where(value: 1).sum(:value)
  end

  # Returns downvotes count this topic has.
  def downvotes_count
    topic_votes.where(value: -1).sum(:value) * -1
  end

  private

  def update_last_activity
    update_column(:last_activity, updated_at)
  end
end
