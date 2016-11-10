require_relative 'seeds_helper.rb'

# Before seeding db we have to clean it first.
SeedsHelper.clean_db

# Users

# Console feedback.
puts 'Start creating users.'

User.create!(
  name: 'admin',
  email: 'admin@admin.com',
  password: 'aaaaaa',
  password_confirmation: 'aaaaaa',
  permissions: 'admin',
  activated: true,
  activated_at: Time.zone.now,
  activation_token_digest: User.digest(User.new_token)
)
# Console feedback.
puts '  Admin user created.'

User.create!(
  name: 'moderator',
  email: 'moderator@moderator.com',
  password: 'mmmmmm',
  password_confirmation: 'mmmmmm',
  permissions: 'moderator',
  activated: true,
  activated_at: Time.zone.now,
  activation_token_digest: User.digest(User.new_token)
)
# Console feedback.
puts '  Moderator user created.'

User.create!(
  name: 'user',
  email: 'user@user.com',
  password: 'uuuuuu',
  password_confirmation: 'uuuuuu',
  permissions: 'user',
  activated: true,
  activated_at: Time.zone.now,
  activation_token_digest: User.digest(User.new_token)
)
# Console feedback.
puts '  Regular user created.'

50.times do |i|
  # All normal users are superheroes genrated by faker gem.
  name = Faker::Superhero.name.truncate(25, omission: '')

  # faker gem sometimes creates strings with symbols forbidden in emails
  # (such as "Al'Rashid"). When this happens, the user is recreated
  # - in loop below.
  user = User.new
  until user.valid?
    user = User.new(
      name: name,
      email: "#{name}#{rand(99)}@#{Faker::Superhero.power}.com".tr(' ', '.'),
      password: 'uuuuuu',
      password_confirmation: 'uuuuuu',
      permissions: 'user',
      activated: true,
      activated_at: Time.zone.now,
      activation_token_digest: User.digest(User.new_token)
    )
  end
  user.save
  puts "  Regular user ##{i} with name #{user.name} created."
end

# Categories
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
