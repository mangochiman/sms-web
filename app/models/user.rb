require 'digest/sha1'
require 'digest/sha2'
require 'rest_client'
class User < ActiveRecord::Base
  set_table_name :users
  set_primary_key :user_id

  has_many :user_roles, :dependent => :destroy
  has_many :api_keys, :foreign_key => :user_id, :dependent => :destroy
  
  validates_presence_of :first_name, :message => ' can not be blank'
  validates_presence_of :last_name, :message => ' can not be blank'
  validates_presence_of :username, :message => ' can not be blank'
  validates_presence_of :phone_number, :message => ' can not be blank'
  validates_presence_of :email, :message => ' can not be blank'
  validates_uniqueness_of :username, :message => ' already taken'
  validates_uniqueness_of :email, :message => ' already taken'
  validates_uniqueness_of :phone_number, :phone_number => ' already taken'

  cattr_accessor :current_user

  def try_to_login
    User.authenticate(self.username,self.password)
  end

  def self.authenticate(login, password)
    u = find :first, :conditions => {:username => login}
    u && u.authenticated?(password) ? u : nil
  end

  def authenticated?(plain)
    encrypt(plain, salt) == password || Digest::SHA1.hexdigest("#{plain}#{salt}") == password || Digest::SHA512.hexdigest("#{plain}#{salt}") == password
  end

  def encrypt(plain, salt)
    encoding = ""
    digest = Digest::SHA1.digest("#{plain}#{salt}")
    (0..digest.size-1).each{|i| encoding << digest[i].to_s(16) }
    encoding
  end

  def set_password
    self.salt = User.random_string(10) if !self.salt?
    self.password = User.encrypt(self.password,self.salt)
  end

  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def self.encrypt(password,salt)
    Digest::SHA1.hexdigest(password+salt)
  end

  def role
    user_roles = self.user_roles
    return "" if user_roles.blank?
    return user_roles.last.role
  end

  def self.generate_api_key
    string = Digest::SHA1.hexdigest([Time.now, rand].join)
    return string
  end

  def self.new_user(params)
    salt = self.random_string(10)
    user = User.new
    user.first_name = params[:first_name]
    user.last_name = params[:last_name]
    user.email = params[:email]
    user.phone_number = params[:phone_number]
    user.password = self.encrypt(params[:password], salt)
    user.salt = salt
    user.username = params[:username]
    user.api_key = self.generate_api_key
    return user
  end

  def self.send_email(params)
    uri = "http://71.19.148.67:5000//send_email"
    RestClient.post(uri,params)
  end

  def self.check_api_key(api_key)
    user = User.find_by_api_key(api_key)
    return user
  end

  def self.api_key_status(user)
    status = "Active"
    return status
  end

  def self.api_key_expiry_date(user)
    expiry_date = Date.today + 30.days
    formatted_expiry_date = expiry_date.strftime("%d/%b/%Y")
    return formatted_expiry_date
  end
  
end

