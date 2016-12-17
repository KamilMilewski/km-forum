# Module with helper methods used in seeds.rb file.
module SeedsHelper
  def self.clean_db
    Post.delete_all
    Topic.delete_all
    Category.delete_all
    User.delete_all
    puts 'Database cleaning: finished.'
  end

  def self.create_admin_account
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
  end

  def self.create_moderator_account
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
  end

  def self.create_user_account
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
  end

  def self.create_users
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
          email: "#{name}#{rand(99)}@#{Faker::Superhero.power}.com"
                 .tr(' ', '.'),
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
  end

  # Populates given category with topics and posts.
  def self.populate_category(category)
    create_topics_for(category)
    create_posts_for(category)
  end

  # Populates given category with topics.
  def self.create_topics_for(category, topic_min_count: 10, topic_max_count: 30)
    # Generate at random how many topics will be created.
    topic_count = rand(topic_min_count..topic_max_count)

    puts "Populating \"#{category.title}\" category begins. " \
         "#{topic_count} topics to create."

    topic_count.times do
      # Genereate topic title.
      title = Faker::Hacker.say_something_smart
      # Generate topic content.
      content = ''
      rand(1..4).times { content += Faker::Hacker.say_something_smart + ' ' }
      # Generate topic author.
      author = User.order('RANDOM()').first
      # Create topic.
      category.topics.create!(
        title: title,
        content: content,
        user_id: author.id
      )
    end
  end

  # Populates all topics in given category with posts.
  def self.create_posts_for(category, post_min_count: 1, post_max_count: 60)
    # Populate with posts each topic in category.
    category.topics.each do |topic|
      # Generate at random how many posts will be created.
      post_count = rand(post_min_count..post_max_count)

      puts "\tPopulating \"#{topic.title.truncate(30)}\" topic begins. " \
           "#{post_count} posts to create."

      # Populate given topic with posts.
      post_count.times do
        # Generate post content.
        content = ''
        rand(1..20).times { content += Faker::Hacker.say_something_smart + ' ' }
        # Generate post author.
        author = User.order('RANDOM()').first
        # Create post.
        topic.posts.create!(
          content: content,
          user_id: author.id
        )
      end
    end
  end
end
