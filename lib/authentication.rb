# Copied from ActiveModel#has_secure_password in order to integrate with GitHub oauth
# https://github.com/rails/rails/blob/3-2-13/activemodel/lib/active_model/secure_password.rb

require 'bcrypt'

module Authentication
  def authenticate(unencrypted_password)
    if BCrypt::Password.new(password_digest) == unencrypted_password
      self
    else
      false
    end
  end

  # Encrypts the password into the password_digest attribute.
  def password=(unencrypted_password)
    @password = unencrypted_password
    unless unencrypted_password.blank?
      self.password_digest = BCrypt::Password.create(unencrypted_password)
    end
  end
end
