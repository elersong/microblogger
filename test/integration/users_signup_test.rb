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
    # TODO Add a test to verify the presence of error messages
  end

  test "valid signup form submission" do
    get signup_path
    name = "Example User"
    email = "user@valid.com"
    password = "password"
    assert_difference "User.count", 1 do
      post_via_redirect users_path, user: {  name: name, email: email, password: password, password_confirmation: password  }
    end
    assert_template "users/show"
    # TODO Add a test to verify the presence of error messages
  end

end
