class Message < ApplicationRecord
  validates :contnet, presence: true
  
  belongs_to :room
  belongs_to :user

  
end
