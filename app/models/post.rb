# Defines forum Post resource.
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  # Mounts PictureUploader on 'picture' column to allow images upload associated
  # with this model. Provided by carrierwave gem.
  mount_uploader :picture, PictureUploader
  validate :picture_size

  validates :content, presence: true
end
