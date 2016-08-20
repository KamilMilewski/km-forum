#1. What is km-forum?
	km-forum is a discussion board application written in ROR.

#2. What is purpose of km-forum?
	km-forum is written mainly for educational purposes.

#3. User stories.
	-As a user I want to be able to create my own account and log in into it.
	-As a user I want to be able to create topic in given category.
	-As a user I want to be able to write posts to others topics.
	-As a user I want to be able to edit my replies and my topics.

	-As an admin I want to be able to do all that regular user can do.
	-As an admin I want to be able to create, edit and delete categories.
	-As an admin I want to be able to delete any post or topic.
	-As an admin I want to be able to delete user account.

#4. Data models.
	Category
		-title:string
		-description:text
	Topic
		-title:string
		-content:text
	post
		-content:text
	User
		-name:string
		-email:string
		-password_digest:string
		-type:string

#5. Data model relations.
	Category
		-has many topics
	Topic
		-has many posts
		-belongs to User
		-belongs to Category
	Post
		-belongs to User and Topic
	User
		-has many topics & posts

#6. Pages.
	-Home page where all categories are listed.
	-Category page where all its topics are listed.
	-Topic page where all posts are listed.
	-Admin control panel.
	-Category new/edit page.
	-Topic new/edit page.
	-Post new/edit page.
	-User new/show page.
