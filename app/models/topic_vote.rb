# KM-Forum user can vote one time for each topic. He can upvote (+1) or
# downvote (-1).
class TopicVote < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  # Vote can be either -1 (downvote) or +1 (vote)
  validates :value, inclusion: { in: [-1, 1] }

  # This validation is also present at db level. But it has to be backed up by
  # ActiveRecord validation as well because otherwise we will get db level
  # exceptions.
  validates_uniqueness_of :user_id, scope: :topic_id
end
