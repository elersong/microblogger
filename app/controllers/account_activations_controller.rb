class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = "Account activated!"
      login user
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
  
  private

  # Rails 4 strong parameters
  def email
    params.require(:email)
  end
  
  # Rails 4 strong parameters
  #def token
  #  params.require(:token)
  #end
  
end
