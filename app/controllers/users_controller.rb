class UsersController < ApplicationController

  before_filter :must_be_signed_in, except: [:new, :create]

  def new
    # return redirect_to PATH if signed_in?
    @user = User.new
  end

  def create
    user_params = params[:user]
    @user = User.new(user_params)

    if User.exists?(email: user_params[:email])
      flash.now[:error] = "There's already an account with that email address!"
      return render :new
    end

    if @user.save
      sign_in(@user)
      return redirect_to root_url # TODO
    else
      flash.now[:error] = "Error - please check your fields and try again."
      return render :new
    end
  end

  def show
    respond_to do |format|
      format.json { return render json: @user }
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile successfully updated."
      return redirect_to expenses_path
    else
      flash.now[:error] = "Error - please check your fields and try again."
      return render :edit
    end
  end

  private

end
