class User < ActiveRecord::Base
  # attributes on the model (saved to db) :name, :email, :password, :password_confirmation
  attr_accessor :remember_token, :activation_token, :reset_token # these are not saved to db, but assoc with user obj
  
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 250 }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  before_save :downcase_email
  
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true
  
  before_create :create_activation_digest
  
  
  ### Model Methods ###
  
  # return the hash digest of a given string (use this for passwords and tokens before db saving)
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # return a random 16 char long base_64 string of url-safe characters
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembers a user in the database for use in persistent sessions through setting a remember token/digest pair
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # returns true if the given token matches the digested version
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # forgets the logged-in user
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Activates an account by setting the db attributes accordingly
  def activate
    self.update_attribute(:activated,    true)
    self.update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # sets password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  # send the password reset email with token
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # returns true if password reset link has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  private
  
  # converts email address attribute to lowercase
  def downcase_email
    self.email = email.downcase
  end
  
  # creates and assigns token for activation and its encrypted digest version
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
end
