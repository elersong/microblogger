module SessionsHelper
  
  #logs in a user
  def login(user)
    session[:user_id] = user.id
  end
  
  # returns the current logged in user, if one exists
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  # returns true if a user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end
  
end
