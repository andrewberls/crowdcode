source 'http://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.11'

gem 'jquery-rails'

gem 'pg'

# Redis and adapters
gem "redis", "~> 3.0.3"
gem "hiredis", "~> 0.4.5"

# Webserver
gem 'thin'

# Search
gem 'sunspot_rails'

# Pagination
gem 'will_paginate'

# Threaded comments
gem 'ancestry'

# Review tags + autocompletion
gem 'acts-as-taggable-on', '~> 2.3.1'

gem 'therubyracer', :platforms => :ruby

# Password encryption
gem 'bcrypt-ruby', '~> 3.0.0'

# Sign-in with GitHUb
gem 'omniauth-github'

# Caching
# gem 'dalli'

# API serializers
# gem 'active_model_serializers', github: 'rails-api/active_model_serializers'

# Seed data generation
gem 'literate_randomizer'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development, :test do
  gem 'letter_opener'
  #gem 'launchy', '2.1.2'
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller'

  # Deployment with capistrano
  gem 'capistrano'

  # Pre-packaged Solr distribution for use in development
  gem 'sunspot_solr'
end
