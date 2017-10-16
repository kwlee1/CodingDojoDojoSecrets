class Secret < ActiveRecord::Base
  validates :content, presence: true
  belongs_to :user
  has_many :likes
  has_many :users, through: :likes, source: :user
end
