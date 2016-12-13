require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KmForum
  # KmForum constants.
  TOPICS_PER_PAGE = 10
  POSTS_PER_PAGE  = 10
  USERS_PER_PAGE  = 10

  TOPIC_CONTENT_TRUNCATE = 40
  POST_CONTENT_TRUNCATE = 40

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
