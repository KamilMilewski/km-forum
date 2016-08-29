class Category < ApplicationRecord
	has_many :topics

	validates :title, presence: true, length: {maximum: 255}
	validates :description, presence: true
end
