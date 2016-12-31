source 'https://rubygems.org'
ruby '2.3.1'

gem 'autoprefixer-rails'
gem 'bcrypt', '3.1.11'
gem 'bootstrap-sass', '3.3.6'
gem 'coffee-rails', '4.2.1'
gem 'jbuilder',     '2.4.1'
gem 'jquery-rails', '4.1.1'
gem 'puma',         '3.4.0'
gem 'sass-rails',   '5.0.6'
gem 'turbolinks',   '5.0.1'
gem 'uglifier',     '3.0.0'
# Provides generator of names etc...
gem 'faker', '1.6.6'
gem 'will_paginate', '3.1.3'
gem 'will_paginate-bootstrap', '1.0.1'
# Image upload...
gem 'carrierwave', '0.11.2'
# and image resize
gem 'mini_magick', '4.5.1'
# Maintanance mode
gem 'turnout'
# Markdown to HTML parser.
gem 'redcarpet', '~> 3.2.2'
# Exposes the python pygments syntax highlighter to Ruby.
gem 'pygments.rb', '~> 0.6.0'
gem 'rails',        '5.0.0.1'

group :development, :test do
  # Background process:
  gem 'delayed_job_active_record'
  gem 'byebug', platform: :mri
  gem 'sqlite3'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
end

group :production do
  gem 'pg'
end

group :test do
  gem 'minitest-reporters',       '1.1.9'
  gem 'rails-controller-testing', '0.1.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
