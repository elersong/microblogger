require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  test "account_activation" do
    user = User.create(name: "Mailer Test User", email: "mailer@test.com",
                      password: "foobar", password_confirmation: "foobar")
    mail = UserMailer.account_activation(user)
    assert_equal "Activate Your Microblogger Account",      mail.subject
    assert_equal [user.email],                              mail.to
    assert_equal ["noreply@microblogger.com"],              mail.from
    assert_match user.name,                                 mail.body.encoded
    assert_match user.activation_token,                     mail.body.encoded
    assert_match CGI::escape(user.email),                   mail.body.encoded
  end  

  test "password_reset" do
    user = users(:michael)
    user.create_reset_digest 
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset",                          mail.subject 
    assert_equal [user.email],                              mail.to
    assert_equal ["noreply@microblogger.com"],                   mail.from
    assert_match user.reset_token,                          mail.body.encoded
    assert_match CGI::escape(user.email),                   mail.body.encoded
  end

end
