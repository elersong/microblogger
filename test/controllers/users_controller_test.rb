require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should redirect from edit page when not logged in" do
    get :edit, id: @user
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_redirected_to login_url
  end

  test "should redirect from user1's edit page when logged in as user2" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert_redirected_to root_url
  end
  
  test "should redirect from user1's update page when logged in as user2" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_redirected_to root_url
  end
  
  test "should redirect away from users index page when not logged in" do
    get :index
    assert_redirected_to login_url
  end
  
  test "should redirect destroy request to login_url when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

end
