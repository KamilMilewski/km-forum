# Defines forum Post resource.
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  # Every change to post is treated as a new activity for corresponding topic.
  after_save :update_topic_last_activity

  # Mounts PictureUploader on 'picture' column to allow images upload associated
  # with this model. Provided by carrierwave gem.
  mount_uploader :picture, PictureUploader
  validate :picture_size

  validates :content, presence: true

  private

  def update_topic_last_activity
    topic.update_column(:last_activity, updated_at)
  end
end
