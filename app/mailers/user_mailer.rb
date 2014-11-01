class UserMailer < ActionMailer::Base
  default from: "noreply@microblogger.com"

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Activate Your Microblogger Account"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
