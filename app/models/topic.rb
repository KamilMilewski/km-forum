class Topic < ApplicationRecord
	has_many :posts
	belongs_to :user
	belongs_to :category, dependent: :destroy
end
