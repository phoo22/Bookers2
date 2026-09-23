class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @users= User.all
    @user = Current.user
    @book= Book.new
  end
    
  def new
    if request.path == new_user_path
      redirect_to user_sign_up_path
      return
    end

    @user = User.new
  end

  def show
    @user= User.find(params[:id])
    @books= @user.books
    @book= Book.new
  end

  def create
    @user = User.new(sign_up_params)
    if @user.save
      start_new_session_for(@user)
      redirect_to user_path(@user), notice: "Welcome, you have signed up successfully!"
    else
      flash.now[:alert] = "error: User could not be created."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user= User.find(params[:id])
  end

  def update
    @user= User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      flash.now[:alert] = "error: User could not be updated."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
  
  def sign_up_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end

  def ensure_correct_user
    @user = User.find(params[:id])

    unless @user == Current.user
      redirect_to user_path(Current.user)
    end
  end
end
