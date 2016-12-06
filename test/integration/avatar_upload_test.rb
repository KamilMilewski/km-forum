require 'test_helper'

class AvatarUploadTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
  end

  test 'should allow user upload custom avatar during profile edit' do
    log_in_as(@user)
    avatar = fixture_file_upload('test/fixtures/kitten.png', 'image/png')

    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email,
        avatar: avatar
      }
    }

    assert assigns(:user).avatar?
  end
end
