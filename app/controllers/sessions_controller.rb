class SessionsController < ApplicationController

  def new
    if url = params[:return_url]
      store_return_url(url)
    end

    return redirect_to reviews_path if signed_in?
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      sign_in(user, permanent: params[:remember_me])
      return redirect_to_return_or_path(reviews_path)
    else
      flash.now[:error] = "Invalid email or password"
      return render :new
    end

  end

  def create_from_github
    omniauth = request.env["omniauth.auth"]
    @user = User.find_by_github_uid(omniauth["uid"]) || User.create_from_omniauth(omniauth)
    sign_in(@user)
    return redirect_to_return_or_path(reviews_path)
  end

  def failure_from_github
    flash[:error] = "Error logging in with GitHub. #{params[:message]}"
    redirect_to login_path
  end

  def destroy
    cookies.delete(:auth_token)
    return redirect_to root_url
  end

  private

  def redirect_to_return_or_path(path)
    redirect_to(session[:return_to] || path)
    clear_return_to
  end

  def clear_return_to
    session.delete(:return_to)
  end

end
