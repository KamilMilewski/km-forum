# Welcome to KM-forum!

## What is KM-forum?

KM-forum is a discussion board application written in ROR.

## What is purpose of KM-forum?

From [wikipedia](https://en.wikipedia.org/wiki/Internet_forum):

    "An Internet forum, or message board, is an online discussion site where
    people can hold conversations in the form of posted messages."

## Getting started

At the command prompt:

1. Install Rails if you haven't yet:

        $ gem install rails

2. Create new folder for an app and clone it. For example from GitHub:

        $ git clone https://github.com/KamilMilewski/km-forum.git

3. Enter forum directory. If you cloned it to 'myforym' directory, then:

        $ cd myforum

4. Install all gems.

        $ bundle install

5. Run database migrations.

        $ rails db:migrate

6. If you want to populate forum with sample data, run:

        $ rails db:seed

7. Using browser go to `http://localhost:3000` and you'll see forum main page.

## Users

There are four types of users. They are ordered by permissions level(admin with
highest permissions and anonymous with the lowest). Every action accessible to
user with lower permissions are by default accessible to all users with higher
permissions. So for example, if anonymous can browse topics - everyone can browse
topics as well.

* admin     (forum administrator)
* moderator (user with elevated permissions)
* user      (just regular forum user)
* anonymous (non logged in user)

## User stories

* As a non logged-in user,
  * I want to access categories index (root) page.
  * I want to access category show (topics index) page.
  * I want to access topic show (posts index) page.

* As a regular user,
  * I want to create new topic.
  * I want to create new post.
  * I want to edit MY OWN topic.
  * I want to destroy MY OWN topic.
  * I want to edit MY OWN post.
  * I want to destroy MY OWN post.
  * I want to access users index page.

* As a moderator,
  * I want to edit EVERY topic.
  * I want to destroy EVERY topic.
  * I want to edit EVERY post.
  * I want to destroy EVERY post.

* As an admin,
  * I want to create new category.
  * I want to edit EVERY category.
  * I want to destroy EVERY category.
  * I want to edit EVERY user account.
  * I want to destroy EVERY user account.

## Data models

* Category
	* title:string
	* description:text
* Topic
	* title:string
	* content:text
	* user_id:integer
	* category_id:integer
* Post
	* content:text
	* user_id:integer
	* topic_id:integer
* User
	* name:string
	* email:string
	* password_digest:string
	* remember_token_digest:string
	* activation_token_digest:string
	* permissions:string

## Data model relations

* Category
	* has many topics
* Topic
	* has many posts
	* belongs to user
	* belongs to category
* Post
	* belongs to user
	* belongs to topic
* User
	* has many topics
	* has many posts

## Pages

* Categories
	* categories index (root)
	* new category
	* edit category
  * show category (topics index)
* Topics
	* new topic
	* edit topic
  * show topic (posts index)
* Posts
	* new post
	* edit post
* Users
	* users index
	* show user (user profile page)
	* edit user (edit user profile page)
	* new user (signup page)
* Sessions
	* new session (login page)
* Others
	* contact page
	* about page
	* admin control panel

## License

KM-forum is released under the [MIT License](http://www.opensource.org/licenses/MIT).
