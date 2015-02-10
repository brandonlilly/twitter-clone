require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: '',
                                    email: 'foo@invalid',
                                    password: 'foo',
                                    password_confirmation: 'bar' }
    assert_template 'users/edit'
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    valid_user = { name: 'Valid Name', email: 'valid@example.com', password: '', password_confirmation: '' }
    patch user_path(@user), user: valid_user
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, valid_user[:name]
    assert_equal @user.email, valid_user[:email]
  end
  
end
