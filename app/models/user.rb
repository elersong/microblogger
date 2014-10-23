class User < ActiveRecord::Base
  # attr_accessor :name, :email, :password, :password_confirmation
  validates :name,  presence: true, length: { maximum: 50 }
  
  validates :email, presence: true, length: { maximum: 250 }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  before_save { self.email = self.email.downcase }
  
  has_secure_password
  validates :password, length: { minimum: 6 }
  
end
