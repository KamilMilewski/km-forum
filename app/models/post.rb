class Post < ApplicationRecord
	belongs_to :user
	belongs_to :topic, dependent: :destroy
end
