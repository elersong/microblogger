class User < ActiveRecord::Base
  # attributes on the model :name, :email, :password, :password_confirmation
  attr_accessor :remember_token
  validates :name,  presence: true, length: { maximum: 50 }
  
  validates :email, presence: true, length: { maximum: 250 }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  before_save { self.email = self.email.downcase }
  
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true
  
  
  ### Model Methods ###
  
  # return the hash digest of a given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # return a random 16 char long base_64 string of url-safe characters
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # returns true if the given token matches the digested version
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # forgets the logged-in user
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end
