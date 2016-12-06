# Defines forum topic resource.
class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy
  belongs_to :user
  belongs_to :category

  # Mounts PictureUploader on 'picture' column to allow images upload associated
  # with this model. Provided by carrierwave gem.
  mount_uploader :picture, PictureUploader
  validate :picture_size

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
end
