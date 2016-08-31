class User < ApplicationRecord
	has_many :topics
	has_many :posts

	#This function requires bcrypt gem installed and password_digest column to be
	#present.It adds following funcionality:
	# -Save securely hashed password digest to the database.
	# -It adds up a pair of virtual attributes: password and password_confirmation.
	# -It adds validation if those two are present and match.
	# -It provides authenticate method that returns user if password is correct and
	#  false otherwise.
	has_secure_password

end
