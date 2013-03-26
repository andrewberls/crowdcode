class SessionsController < ApplicationController

  def new
    # return redirect_to reviews_path if signed_in?
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
    redirect_to root_url
  end

  def failure_from_github
    flash[:error] = "Error logging in with GitHub. #{params[:message]}"
    redirect_to login_path
  end

  def destroy
    cookies.delete(:auth_token)
    return redirect_to root_url
  end

  # def forgot_password
  #   # Send email with generated reset token

  #   if request.post?
  #     user   = User.find_by_email(params[:email])
  #     blank  = user.blank?
  #     unauth = signed_in? && params[:email] != current_user.email

  #     if blank || unauth
  #       flash.now[:error] =
  #       if blank
  #         "We couldn't find an account with that email!"
  #       elsif unauth
  #         "Invalid email."
  #       end
  #       return render :forgot_password
  #     end

  #     # Expire any existing tokens for this user
  #     ResetToken.where(user_id: user.id).each(&:mark_used)

  #     token = generate_reset_token(user)
  #     PasswordsMailer.reset(token).deliver
  #     flash[:success] = "A email has been sent to #{user.email} with instructions on resetting your password!"
  #     return redirect_to forgot_password_path
  #   end
  # end

  # before_filter :find_reset_token, only: :reset_password
  # def reset_password
  #   # Reset a user's password

  #   if request.post?
  #     return redirect_bad_token if @token.blank? || @token.invalid?

  #     password = params[:password]
  #     if password != params[:password_confirmation]
  #       @user.errors.add :password, "doesn't match confirmation"
  #       return render :reset_password
  #     end

  #     if @user.update_attributes(password: password)
  #       @token.mark_used
  #       login_user(@user)
  #       flash[:success] = "Password successfully reset!"
  #       return redirect_to expenses_path
  #     else
  #       return render :reset_password
  #     end
  #   end
  # end

  private

  def redirect_to_return_or_path(path)
    redirect_to(session[:return_to] || path)
    clear_return_to
  end

  def clear_return_to
    session.delete(:return_to)
  end

  # def generate_reset_token(user)
  #   ResetToken.create(user: user)
  # end

  # def find_reset_token
  #   @token = ResetToken.find_by_token(params[:token])
  #   return redirect_bad_token if @token.blank? || @token.invalid?

  #   @user  = @token.user
  # end

  # def redirect_bad_token
  #   flash[:error] = "Token is invalid."
  #   return redirect_to forgot_password_path
  # end

end
