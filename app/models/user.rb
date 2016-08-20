class User < ApplicationRecord
	has_many :topics
	has_many :posts
end
