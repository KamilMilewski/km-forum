require 'test_helper'
include ActionView::Helpers::DateHelper

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @another_user = users(:user_4)
  end

  test 'should NOT allow enter user show for not logged in user' do
    get user_path(@user)
    assert_friendly_forwarding_notice
  end

  test 'user show page' do
    log_in_as(@user)
    get user_path(@another_user)
    # Assert page layout.
    assert_match CGI.escapeHTML(@another_user.name), response.body,
                 'User name should be present'
    assert_match CGI.escapeHTML(@another_user.email), response.body,
                 'User email should be present'
    assert_match CGI.escapeHTML(time_ago_in_words(@another_user.activated_at)),
                 response.body,
                 'User joined at should be present'
    assert_match CGI.escapeHTML(@another_user.permissions), response.body,
                 'User account type should be present'
    assert_match CGI.escapeHTML(time_ago_in_words(@another_user.recent_activity
                                .updated_at)), response.body,
                 'User last activity at should be present'
    # User posts count should be present.
    assert_select 'dd', @another_user.posts.count.to_s
    # User topics count should be present.
    assert_select 'dd', @another_user.topics.count.to_s

    # Recent activities. Activity is topic or post user created.
    @another_user.recent_activities.each do |activity|
      assert_match markdown(activity.content), response.body,
                   'Activity content should be present'
      assert_match CGI.escapeHTML(time_ago_in_words(activity.created_at)),
                   response.body,
                   'Activity created_at should be present'
      assert_match CGI.escapeHTML(time_ago_in_words(activity.updated_at)),
                   response.body,
                   'Activity updated_at should be present'
      # Link to activity
      if activity.class == Topic
        assert_select 'a[href=?]', topic_path(activity)
      elsif activity.class == Post
        assert_select 'a[href=?]', topic_path(activity.topic)
      end
    end
  end

  test 'not activated user show page' do
    @another_user.update_columns(activated: false, activated_at: nil)
    @another_user.reload
    log_in_as(@admin)
    get user_path(@another_user)
    # Assert there is info that user is not activated.
    assert_match 'not activated', response.body
  end
end
