# Defines forum topic resource.
class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy
  belongs_to :user
  belongs_to :category

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

  private

  def update_last_activity
    update_column(:last_activity, updated_at)
  end
end
