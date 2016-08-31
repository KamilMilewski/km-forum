class Category < ApplicationRecord
	has_many :topics, dependent: :destroy

	validates :title, presence: true, length: {maximum: 255}
end
