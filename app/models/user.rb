# Defines forum User resource.
class User < ApplicationRecord
  # This function requires bcrypt gem installed and password_digest column to be
  # present. It adds following funcionality:
  # -Save securely hashed password digest to the database.
  # -It adds up a pair of virtual attributes: password and
  # password_confirmation.
  # -It adds validation if those two are present and does match.
  # -It provides authenticate method that returns user if password is correct
  # and false otherwise.
  has_secure_password

  # Format constants used for validations.
  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  PERMISSIONS_FORMAT = /\Auser\z|\Amoderator\z|\Aadmin\z/

  # Virtual field connected to remember_token_digest in db.
  attr_accessor :remember_token
  attr_accessor :activation_token
  attr_accessor :password_reset_token

  # Model relations:
  has_many :topics
  has_many :posts
  has_many :post_votes

  # Mounts PictureUploader on 'picture' column to allow images upload associated
  # with this model. Provided by carrierwave gem.
  mount_uploader :avatar, AvatarUploader
  validate :avatar_size

  # Callbacks:
  # For consistency we will store all emails as lower-case.
  before_save :downcase_email
  before_create :create_activation_digest

  # Validations:
  validates :name, presence: true, length: { maximum: 25 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: EMAIL_FORMAT },
                    uniqueness: { case_sensitive: false }

  # User can have only three types of permissions: user, moderator or admin.
  validates :permissions, presence: true, format: { with: PERMISSIONS_FORMAT }
  # has_secure_password checks if password is not nil during creation. After
  # then we can allow password to be nil during user profile edit for example.
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Class methods:
  # Create random string. Used for token generation.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Create digest of a given string
  def self.digest(string)
    # cost defines computational cost of decrypting digested password. The lower
    # the cost the faster is digest creation. Statement below arranges for low
    # cost in test and development environment and high in production.
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end

    BCrypt::Password.create(string, cost: cost)
  end

  # Remembers logged in user (when remember me checkbox is checked).
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_token_digest, User.digest(remember_token))
  end

  # Forgets previously remembered user.
  def forget
    self.remember_token = nil
    update_attribute(:remember_token_digest, nil)
  end

  # Activates an user account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends an account activation email.
  def send_activation_email
    UserMailer.account_activation(self, activation_token).deliver_later
  end

  # Sends an password reset email.
  def send_password_reset_email
    create_password_reset_digest
    update_attribute(:sent_reset_at, Time.zone.now)
    UserMailer.password_reset(self).deliver_now
  end

  # Checks if password reset request expired.
  def password_reset_token_expired?
    sent_reset_at < 1.hour.ago
  end

  # There are two possible attributes for this method:
  # -remember
  # -activation
  # -password_reset
  # They correspond to model virtual fields:
  # -rember_token
  # -activation_token
  # -password_reset_token
  # Also, note that there is similar method 'authenticate' provided by
  # has_secure_password method intended to confirm if user password is correct.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_token_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Checks if user has admin level permissions.
  def admin?
    permissions == 'admin'
  end

  # Checks if user has moderator level permissions.
  def moderator?
    permissions == 'moderator'
  end

  # Checks if user has user level permissions.
  def user?
    permissions == 'user'
  end

  # Check if user is a owner of given resource. For example post or topic.
  def owner_of(resource)
    id == resource.user_id ? true : false
  end

  # Returns newest user post (created or edited)
  def recent_post
    (recent_posts count: 1)[0]
  end

  # Returns newest user topic (created or edited)
  def recent_topic
    (recent_topics count: 1)[0]
  end

  # Returns top X (10 by default) user posts.
  def recent_posts(count: 10)
    Post.reorder(updated_at: :desc).where(user_id: id).limit(count)
  end

  # Returns top X (10 by default) user topics.
  def recent_topics(count: 10)
    Topic.reorder(updated_at: :desc).where(user_id: id).limit(count)
  end

  # Returns last user activity (post or topic)
  def recent_activity
    (recent_activities count: 1)[0]
  end

  # Gives collection of last user activities (Topics and posts)
  def recent_activities(count: 10)
    posts  = Post.reorder(updated_at: :desc).where(user_id: id).limit(count)
    topics = Topic.reorder(updated_at: :desc).where(user_id: id).limit(count)
    activities = posts + topics
    activities.sort! { |x, y| y.updated_at <=> x.updated_at }
    activities.first(count)
  end

  # Returns user vote on given resource. If user hasn't voted then nil is
  # returned.
  def find_vote_on(resource)
    if resource.class == Post
      PostVote.find_by(user_id: id, post_id: resource.id)
    elsif resource.class == Topic
      TopicVote.find_by(user_id: id, topic_id: resource.id)
    end
  end

  private

  # Callbacks methods. No need for them to be public.
  def downcase_email
    self.email = email.downcase
  end

  # Creates activation token and corresponding activation digest in db during
  # user account creation. Activation token is send to user via email to new
  # user. If user will try to activate account with token that match digest in
  # db then the account will be activated.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_token_digest = User.digest(activation_token)
  end

  def create_password_reset_digest
    self.password_reset_token = User.new_token
    update_attribute(:password_reset_token_digest,
                     User.digest(password_reset_token))
  end

  def avatar_size
    return if avatar.size < 2.megabytes
    errors.add(:avatar, 'should be less than 5MB')
  end
end
