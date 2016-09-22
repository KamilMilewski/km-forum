User.delete_all

User.create!(
  name: 'admin',
  email: 'admin@admin.com',
  password: 'aaaaaa',
  password_confirmation: 'aaaaaa',
  permissions: 'admin'
)

User.create!(
  name: 'moderator',
  email: 'moderator@moderator.com',
  password: 'aaaaaa',
  password_confirmation: 'aaaaaa',
  permissions: 'moderator'
)

User.create!(
  name: 'user',
  email: 'user@user.com',
  password: 'ssssss',
  password_confirmation: 'ssssss',
  permissions: 'user'
)

50.times do |user|
  # all normal users are superheroes genrated by faker gem
  name = Faker::Superhero.name.truncate(25, omission: '')
  User.create!(
    name: name,
    email: "#{name}#{rand(99)}@#{Faker::Superhero.power}.com".gsub(' ', ''),
    password: 'ssssss',
    password_confirmation: 'ssssss',
    permissions: 'user'
)
end
