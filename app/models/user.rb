require 'authentication'

class User < ActiveRecord::Base
  include Authentication

  attr_accessible :username, :email, :password, :password_confirmation

  attr_reader :password

  validate :password_for_non_oauth

  validates :username, presence: true, length: { maximum: 50 }

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    format: { with: valid_email_regex },
    uniqueness: { case_sensitive: false }

  before_create :generate_auth_token

  def self.create_from_omniauth(omniauth)
    User.new do |u|
      u.github_uid = omniauth['uid']
      u.username   = omniauth['info']['nickname']
      u.email      = omniauth['info']['email']
      u.save!
    end
  end

  private

  # Non-oauth users (i.e., 'regular' accounts) must have a password
  def password_for_non_oauth
    password_invalid = password_digest.blank? || password.length < 5
    if github_uid.blank? && password_invalid
      errors.add(:password, "must be at least 5 characters")
    end
  end

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

end
