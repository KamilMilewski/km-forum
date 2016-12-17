task reset_kmf: :environment do
  # It will take some time. Let's put app to maintenance mode.
  system 'bundle exec rake maintenance:start ' \
  ' reason="KMForum resets its database.' \
  ' It may take a minute."'

  load(Rails.root.join('db', 'reset_kmf.rb'))

  # We are finished. Let's disable maintenance mode.
  system 'bundle exec rake maintenance:end'
end
