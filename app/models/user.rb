class User < ApplicationRecord
	has_many :topics
	has_many :posts

	# For consistency we will store all emails as lower-case
	before_save { email.downcase! }

	validates :name, presence: true, length: {maximum: 25}

	EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255},
										format: {with: EMAIL_FORMAT},
										uniqueness: {case_sensitive: false}

	# User can have only three types of permissions: user, moderator or admin
	PERMISSIONS_FORMAT = /\Auser\z|\Amoderator\z|\Aadmin\z/
	validates :permissions, presence: true, format: {with: PERMISSIONS_FORMAT}

	# This function requires bcrypt gem installed and password_digest column to be
	# present. It adds following funcionality:
	# -Save securely hashed password digest to the database.
	# -It adds up a pair of virtual attributes: password and password_confirmation.
	# -It adds validation if those two are present and match.
	# -It provides authenticate method that returns user if password is correct and
	#  false otherwise.
	has_secure_password
	validates :password, presence: true, length: {minimum: 6}

	# User class method. Create digest of a given string
	def User.digest(string)
		# cost defines computational cost of decrypting digested password. The lower
		# cost the faster is creating digest. Line below arranges for low cost in
		# test and development environment and high in production.
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
																									BCrypt::Engine.cost

		BCrypt::Password.create(string, cost: cost)
	end
end
