ActiveRecord::Schema.define(version: 20_161_109_105_538) do
  create_table 'categories', force: :cascade do |t|
    t.string   'title'
    t.text     'description'
    t.datetime 'created_at',  null: false
    t.datetime 'updated_at',  null: false
  end

  create_table 'posts', force: :cascade do |t|
    t.text     'content'
    t.integer  'topic_id'
    t.integer  'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['topic_id'], name: 'index_posts_on_topic_id'
    t.index ['user_id'], name: 'index_posts_on_user_id'
  end

  create_table 'topics', force: :cascade do |t|
    t.string   'title'
    t.text     'content'
    t.integer  'category_id'
    t.datetime 'created_at',  null: false
    t.datetime 'updated_at',  null: false
    t.integer  'user_id'
    t.index ['category_id'], name: 'index_topics_on_category_id'
    t.index ['user_id'], name: 'index_topics_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string   'name'
    t.string   'email'
    t.string   'password_digest'
    t.string   'permissions', default: 'user'
    t.datetime 'created_at',                               null: false
    t.datetime 'updated_at',                               null: false
    t.string   'remember_token_digest'
    t.string   'activation_token_digest'
    t.boolean  'activated', default: false
    t.datetime 'activated_at'
    t.index ['email'], name: 'index_users_on_email', unique: true
  end
end
