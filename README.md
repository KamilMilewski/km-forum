# Welcome to KMForum!

## What is KMForum?

KMForum is a discussion board application written in [Ruby on Rails](http://rubyonrails.org/) and [Bootstrap](http://getbootstrap.com/).

## Working example

You can play with sandbox version [here](https://km-forum.herokuapp.com/).

## What is purpose of KMForum?

From [wikipedia](https://en.wikipedia.org/wiki/Internet_forum):

    "An Internet forum, or message board, is an online discussion site where
    people can hold conversations in the form of posted messages."

## Features

* Markdown formating for posts.
* Code blocks with syntax highlighting.
* Custom user avatars with [Gravatar](http://en.gravatar.com/) as a default.
* Custom built authentication system.
* Custom built authorization system.
* Account activatin via email.
* Password reset via email.
* Custom built voting system.
* Responsivness to mobile devices.

## Getting started

At the command prompt:

1. Install Rails if you haven't yet:

        $ gem install rails

2. Create new folder for an app and clone it. For example from GitHub:

        $ git clone https://github.com/KamilMilewski/km-forum.git

3. Enter forum directory. If you cloned it to 'myforym' directory, then go:

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

* As an anonymous user,
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
  * I want to reset my password (via email).
  * I want to upload picture for my post and topic.
  * I want to upload my custom avatar picture or use Gravatar.
  * I want to vote for posts and topics.
  * I need to activate my account before use (via email).

* As a moderator,
  * I want to edit EVERY topic excluded admin's topics.
  * I want to destroy EVERY topic excluded admin's topics.
  * I want to edit EVERY post excluded admin's posts.
  * I want to destroy EVERY post excluded admin's posts.
  * I want to edit EVERY user account excluded admin's account.

* As an admin,
  * I want to create new category.
  * I want to edit EVERY category.
  * I want to destroy EVERY category.
  * I want to edit EVERY user account.
  * I want to destroy EVERY user account.

* As an anonymous I'm being redirected to login page (FRIENDLY FORWARDING) when
  * I try to access user edit page.
  * I try to access category edit page.
  * I try to access topic edit page.
  * I try to access post edit page.
  * I try to access users index page.

* As an anonymous I'm being redirected to main page (ACCESS CONTROL) when
  * I try to issue UPDATE or DELETE request to User resource.
  * I try to issue POST, UPDATE or DELETE request to Category resource.
  * I try to issue POST, UPDATE or DELETE request to Topic resource.
  * I try to issue POST, UPDATE or DELETE request to Post resource.

* As a logged in user I'm being redirected to main page (ACCESS CONTROL) when
  i try to perform action that require higher permissions than I have -
  including GET requests.

## Data models

* Category
 * title:string
 * description:text
* Topic
 * title:string
 * content:text
 * picture:string
 * user_id:integer
 * category_id:integer
 * last_activity:datetime
* Post
 * content:text
 * picture:string
 * user_id:integer
 * topic_id:integer
* User
 * name:string
 * email:string
 * password_digest:string
 * remember_token_digest:string
 * activation_token_digest:string
 * password_reset_token_digest:string
 * permissions:string
 * avatar:string

## Data model relations

* Category
 * has many topics
* Topic
 * belongs to ser
 * belongs to category
 * has many posts
 * has many topic_votes
* Post
 * belongs to user
 * belongs to topic
 * has many post_votes
* User
 * has many topics
 * has many posts
 * has many post_votes
 * has many topic_votes
* TopicVotes
 * belongs to user
 * belongs to topic
* PostVotes
 * belongs to user
 * belongs to post

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
* Password resets
 * enter your email (password resets new)
 * change your password (password resets edit)
* Others
 * contact page
 * about page

## Legal stuff

KMForum is available under an [MIT](http://www.opensource.org/licenses/MIT)-style license. Copyright © 2016 Kamil Milewski

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
