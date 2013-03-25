class User < ActiveRecord::Base

  attr_accessible :username, :email, :password, :password_confirmation

  # TODO: disable validations if github_uid present?
  # has_secure_password

 before_create :generate_auth_token

  def self.create_from_omniauth(omniauth)
    User.new.tap do |user|
      user.github_uid = omniauth['uid']
      user.username  = omniauth['info']['nickname']
      user.email = omniauth['info']['email']
      user.save!
    end
  end

  private

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

end
