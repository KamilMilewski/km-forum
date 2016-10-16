module SeedsHelper
  # When we want module-level function we have to name them like self.method_name.
  # This way we can require module and then methods like ModuleName.method_name.

  def self.clean_db
    # Console feedback.
    puts "Database cleaning: begins."

    User.destroy_all
    Category.destroy_all
    Topic.destroy_all
    Post.destroy_all

    # Console feedback.
    puts "Database cleaning: finished."
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

    # Console feedback.
    puts "Populating \"#{category.title}\" category begins. " \
         "#{topic_count} topics to create."

    topic_count.times do

      # Genereate topic title.
      title = Faker::Hacker.say_something_smart

      # Generate topic content.
      content = ''
      rand(1..4).times{ content += Faker::Hacker.say_something_smart + ' ' }

      # Generate topic author.
      author = User.order("RANDOM()").first

      # Create topic.
      topic = category.topics.create!(
        title: title,
        content: content,
        user: author
      )
    end
  end

  # Populates all topics in given category with posts.
  def self.create_posts_for(category, post_min_count: 1, post_max_count: 60)

    # Populate with posts each topic in category.
    category.topics.each do |topic|

      # Generate at random how many posts will be created.
      post_count = rand(post_min_count..post_max_count)

      # Console feedback.
      puts "\tPopulating \"#{topic.title.truncate(30)}\" topic begins. " \
           "#{post_count} posts to create."

      # Populate given topic with posts.
      post_count.times do

        # Generate post content.
        content = ''
        rand(1..20).times { content += Faker::Hacker.say_something_smart + ' ' }

        # Generate post author.
        author = User.order("RANDOM()").first

        # Create post.
        topic.posts.create!(
          content: content,
          user: author
        )

      end
    end
  end

end
