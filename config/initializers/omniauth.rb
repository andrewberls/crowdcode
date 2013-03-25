# TODO: move these
github_id = '48e1fd28db7931005d78'
github_secret = 'bb54a73e7e608e7635df021cd22e2a0d2aa0c0e6'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, github_id, github_secret
end
