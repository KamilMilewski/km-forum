# This controller apply only to SANDBOX mode of KMForum.
class SandboxDbResetsController < ApplicationController
  # Resets KMForum database to this app speciffic starting point - with three
  # users created - admin, moderator and regular user.
  def reset
    load(Rails.root.join('db', 'reset_kmf.rb'))
  end

  # Populates KMForum database with sample, fake data.
  def seed
    load(Rails.root.join('db', 'reset_kmf.rb'))
    load(Rails.root.join('db', 'populate_kmf.rb'))
  end
end
