class User < ActiveRecord::Base
  has_many :order
  has_many :batch
  has_many :transaction
  has_one :role

  validates_uniqueness_of :login
  validates_presence_of :name, :login
  validates_length_of :name, :login, :within => 3..40

  before_save :validate_password

  attr_accessor :password, :password_confirmation
  attr_protected :id, :password_salt

  def self.auth(login, password)
    user = User.find(:first, :conditions =>["login = ?", login])
    return nil if user.nil?
    return user if User.encrypt(password, user.password_salt) == user.password_hash
    return nil
  end
  
  def password=(pass)
    return if pass.blank?
    @password = pass
    self.password_salt = User.generate_salt if !self.password_salt?
    self.password_hash = User.encrypt(pass, self.password_salt)
  end

  private
  
  def validate_password
    return true if @password.blank? and @password_confirmation.blank? and !self.new_record?
    errors.add(:password, "can't be blank") if @password.blank?
    errors.add(:password, "is too short (minimum is 5 characters)") if !@password.nil? and @password.length < 5
    errors.add(:password_confirmation, "can't be blank") if @password_confirmation.blank?
    errors.add(:password_confirmation, "doesn't match") if @password != @password_confirmation
    return false if errors.size > 0
  end
  
  protected
  
  def self.encrypt(pass, salt)
    return Digest::SHA256.hexdigest(pass + salt)
  end
  
  def self.generate_salt
    return [Array.new(6){rand(256).chr}.join].pack("m").chomp
  end
  
end
