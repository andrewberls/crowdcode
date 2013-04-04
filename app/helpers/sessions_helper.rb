module SessionsHelper

  def github_signin_button
    # <a href="/auth/github" class="btn btn-full btn-github">Sign in with GitHub</a>
    link_to 'Sign in with GitHub', '/auth/github', class: 'btn btn-full btn-github'
  end

end
