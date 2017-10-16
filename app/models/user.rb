class User < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  has_secure_password
  validates :password, presence: true, on: :create
  validates :name, :email, presence: true
  validates :email, uniqueness: true 
  validates :email, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
  before_save :email_lowercase
  has_many :secrets
  has_many :likes, dependent: :destroy 
  has_many :secrets_liked, through: :likes, source: :secret 
  def email_lowercase
    email.downcase!
  end 
end
