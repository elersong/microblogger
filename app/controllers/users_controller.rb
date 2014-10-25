class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:edit, :update]
  before_action :correct_user,    only: [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      flash[:success] = "Welcome to Microblogger, #{@user.name}!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    ## == Before Filters == ##
    
    # confirms that there is a user logged in right now
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # confirms the correct user is logged in
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user? @user
    end
  
end
