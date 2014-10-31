require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Validation Test User", email: "valid@valid.valid", 
                      password: "password123", password_confirmation: "password123")
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  test "name should not exceed 50 chars" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not exceed 250 chars" do
    @user.email = "a" * 251
    assert_not @user.valid?
  end
  
  test "email validation should accept valid email addresses" do
    valid_emails = %w[user@example.com example_user34@gmail.edu smith+5@masrhall.net alex.bob@blue.info]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end
  
  test "email validation should not accept invalid email addresses" do
    invalid_emails = %w[userexample.com example_user34@gmail smith+5@masrhall,net alex.bob@blue_info test@..com]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should not be valid"
    end
  end
  
  test "email addresses should each be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should have a minimum length of 6 characters" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember,"")
  end

end
