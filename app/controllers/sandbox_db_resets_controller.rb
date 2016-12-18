# This controller apply only to SANDBOX mode of KMForum.
class SandboxDbResetsController < ApplicationController
  # Resets KMForum database to this app speciffic starting point - with three
  # users created - admin, moderator and regular user.
  def reset
    # Reset KMForum db.
    system 'bundle exec rake reset_kmf &'
    flash[:info] = 'Database reset pending. Site will be in maintenance mode' \
                   ' for less than a minute'
    redirect_to root_url
  end

  # Populates KMForum database with sample, fake data.
  def seed
    # Reset and seed KMForum db.
    system 'bundle exec rake populate_kmf &'
    flash[:info] = 'Database is populating itself with sample data. Site will' \
                   ' turn into maintenance mode for few minutes.'
    redirect_to root_url
  end
end
