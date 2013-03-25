class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def create
    @user = User.new(params[:id])

    if @user.save
      flash[:success] = "Successful"
      redirect_to posts_path
    else
      flash.now[:error] = "Something went wrong!"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.new(params[:id])

    if @user.save
      flash[:success] = "Successful"
      redirect_to posts_path
    else
      flash.now[:error] = "Something went wrong!"
      render :new
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to posts_path
  end
end
