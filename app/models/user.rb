class User < ActiveRecord::Base
  
  def password=(pass)
    return if pass.blank?
    salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    self.password_salt, self.password_hash =
      salt, Digest::SHA256.hexdigest(pass + salt)
  end
  
  def password
    return nil
  end
  
  def self.auth(username, password)
    user = User.find(:first, :conditions =>"login='#{username}'")
    return user if user.nil?
    
    digest = Digest::SHA256.hexdigest(password + user.password_salt)
    if user.blank? || digest != user.password_hash
      return nil
    else
      return user
    end
  end
end
