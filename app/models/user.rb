class User < ActiveRecord::Base
  has_many :order
  has_many :batch
  has_many :transaction
  belongs_to :role

  validates_uniqueness_of :login
  validates_presence_of :name, :login, :role_id
  validates_length_of :name, :login, :within => 3..40

  before_save :validate_password

  attr_accessor :password, :password_confirmation
  attr_protected :id, :password_salt

  def self.auth(login, password)
    user = User.find :first, :conditions =>["login = ?", login], :include=>[:role]
    return nil if user.nil?
    return user if User.encrypt(password, user.password_salt) == user.password_hash
    return nil
  end

  def get_dashboard_permissions
    permissions = []

    # You shall not question my god.
    if self.role_id == 1 # Sure there is a better way
      perm = PermissionRole.find :all, :conditions=>{:permissions=>{:action=>'consult'}}, :include=>[:permission]
    else
      perm = PermissionRole.find :all, :conditions=>{:role_id=>self.role_id, :permissions=>{:action=>'consult'}}, :include=>[:permission]
    end

    perm.each do |pr|
      permissions << pr.permission.module
    end
    return permissions
  end

  def password=(pass)
    return if pass.blank?
    @password = pass
    self.password_salt = User.generate_salt if !self.password_salt?
    self.password_hash = User.encrypt(pass, self.password_salt)
  end

  def has_global_permission?(controller, action)
    return true if self.role_id == 1 # Again, don't you dare

    valid = false
    permission_roles = PermissionRole.find_with_permissions(self.role_id, controller, 'global')
    puts "GLOBAL::action: #{action} - controller: #{controller}"
    puts permission_roles.inspect
    permission_roles.each do |pm|
      puts "GLOBAL::permission.action: #{pm.permission.action} - permission.module: #{pm.permission.module}"
      if pm.permission.action == 'consult' and Permission.is_consult?(action)
        valid = true
      elsif pm.permission.action == 'modify' and Permission.is_modify?(action)
        valid = true
      elsif pm.permission.action == 'delete' and Permission.is_delete?(action)
        valid = true
      elsif pm.permission.action == 'recalculate' and Permission.is_recalculate?(action)
        valid = true
      elsif pm.permission.action == 'import' and Permission.is_import?(action)
        valid = true
      elsif pm.permission.action == 'reprocess' and Permission.is_reprocess?(action)
        valid = true
      elsif pm.permission.module == 'reports' and pm.permission.action == action
        valid = true
      end
      return true if valid
    end
    return false
  end

  def has_module_permission?(controller, action)
    return true if self.role_id == 1 # You should be able to see it by now Mr. Anderson

    permission_roles = PermissionRole.find_with_permissions(self.role_id, controller, 'module')
    permission_roles.each do |pm|
      puts "MODULE::action: #{action} - controller: #{controller}"
      puts "MODULE::permission.action: #{pm.permission.action} - permission.module: #{pm.permission.module}"
      return true if pm.permission.action == action
    end
    return false
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
