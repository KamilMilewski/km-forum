class Topic < ApplicationRecord
	has_many :posts, dependent: :destroy
	belongs_to :user
	belongs_to :category

	validates :title, presence: true, length: {maximum: 255}
	validates :content, presence: true
end
