# This rake task mimics db:seed.
task populate_kmf: :environment do
  # It will take quite long time. Let's put app to maintenance mode.
  system 'bundle exec rake maintenance:start ' \
  ' reason="KMForum seeds database with sample data.' \
  ' It may take a few minutes."'

  load(Rails.root.join('db', 'reset_kmf.rb'))
  load(Rails.root.join('db', 'populate_kmf.rb'))

  # We are finished. Let's disable maintenance mode.
  system 'bundle exec rake maintenance:end'
end
