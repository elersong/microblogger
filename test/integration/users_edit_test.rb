require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), user: { name: '',
                                    email: 'foo@invalid',
                                    password: 'does not',
                                    password_confirmation: 'match' }
    assert_template 'users/edit'
  end
  
  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    name = "Successfull Lee Edited"
    email = "email@email.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: '',
                                    password_confirmation: '' }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

end
