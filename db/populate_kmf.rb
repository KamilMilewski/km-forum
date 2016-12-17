require_relative 'seeds_helper.rb'
# Populates KMForum with random data.

# Creating users
SeedsHelper.create_users

# Creating categories
# Code below generates 6 categories populated with random hacker phrases and
# one empty category.
category = Category.create!(
  title: 'Ruby',
  description: 'A dynamic, open source programming language with a focus on
  simplicity and productivity.'
)
SeedsHelper.populate_category(category)

category = Category.create!(
  title: 'Ruby on Rails',
  description: 'Server-side web application framework written in Ruby.'
)
SeedsHelper.populate_category(category)

category = Category.create!(
  title: 'Elixir',
  description: 'Dynamic, functional language designed for building scalable
  and maintainable applications'
)
SeedsHelper.populate_category(category)

category = Category.create!(
  title: 'Phoenix',
  description: 'A productive web framework that does not compromise speed
  and maintainability.'
)
SeedsHelper.populate_category(category)

category = Category.create!(
  title: 'JavaScript',
  description: 'High-level, dynamic, untyped, and interpreted programming ' \
               'language.'
)
SeedsHelper.populate_category(category)

category = Category.create!(
  title: 'AngularJS',
  description: 'JavaScript-based open-source front-end web application ' \
               'framework'
)
SeedsHelper.populate_category(category)

Category.create!(
  title: 'Empty category',
  description: ''
)
