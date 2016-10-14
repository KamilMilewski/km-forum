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
  password: 'mmmmmm',
  password_confirmation: 'mmmmmm',
  permissions: 'moderator'
)

User.create!(
  name: 'user',
  email: 'user@user.com',
  password: 'uuuuuu',
  password_confirmation: 'uuuuuu',
  permissions: 'user'
)

50.times do
  # All normal users are superheroes genrated by faker gem.
  name = Faker::Superhero.name.truncate(25, omission: '')

  # faker gem sometimes creates strings with symbols forbidden in emails
  # (such as "Al'Rashid"). When this happens, the user is recreated
  # - in 'until' loop below.
  user = User.new
  until user.valid?
    user = User.new(
      name: name,
      email: "#{name}#{rand(99)}@#{Faker::Superhero.power}.com".gsub(' ', '.'),
      password: 'uuuuuu',
      password_confirmation: 'uuuuuu',
      permissions: 'user'
    )
  end
  user.save

end
