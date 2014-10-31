class UserMailer < ActionMailer::Base
  default from: "noreply@microblogger.com"

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Activate Your Microblogger Account"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
