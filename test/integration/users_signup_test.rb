require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup form submission" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, user: {  name: "",
                                email: "user@invalid",
                                password: "foo",
                                password_conformation: "bar"  }
    end
    assert_template "users/new"
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test "valid signup form submission" do
    get signup_path
    name = "Example User"
    email = "user@valid.com"
    password = "password"
    assert_difference "User.count", 1 do
      post_via_redirect users_path, user: {  name: name, email: email, password: password, password_confirmation: password  }
    end
    assert_template "users/show"        # Redirect to user#show page with new user info
    assert_select 'div.alert-success'   # A success alert is shown in view
    assert_not flash.nil?               # Flash hash isn't nil
    assert is_logged_in?
  end

end
