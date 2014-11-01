module SessionsHelper

  # Logs in the given user.
  def login(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember # create and assign token to user, digest and save token digest to db
    cookies.permanent.signed[:user_id] = user.id                # permanent() and signed() are just modifiers of the cookies obj
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) # permanent cookie will last longer than session
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])   # where line 10 and line 11 come together to make sure 
                                                                            # the "user" variable has the associated :remember_token/digest
                                                                            # BENEFIT: By changing the :remember_token (logging in on another
                                                                            # machine), a "user" can effectievly log-out any other browsers that
                                                                            # are logged in as that "user"... because now the token on that second
                                                                            # party browser will no longer match the digest in the database. 
        login user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  # Forgets a persistent session (using :remember_token/digest to identify a client as no longer active)
  def forget(user)
    user.forget     # clear token digest from db
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # returns true if the given user is current_user
  def current_user?(user)
    user == @current_user
  end
  
  # redirects to stored location OR to the default
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # temporarily stores the url trying to be accessed
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
