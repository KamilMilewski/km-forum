require_relative 'seeds_helper.rb'
# Cleans DB and creates three generic user accounts.
SeedsHelper.clean_db
SeedsHelper.create_admin_account
SeedsHelper.create_moderator_account
SeedsHelper.create_user_account
