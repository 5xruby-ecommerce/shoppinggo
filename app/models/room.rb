class Room < ApplicationRecord
  validates :sender_id, uniqueness: { scope: :receiver_id }
  has_many :messages
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'

  scope :participating, -> (user) do
    where("(rooms.sender = ? OR rooms.receiver_id = ?)", user.id, user.id)
  end

  scope :between ,->(sender_id, receiver_id) {
    where(sender_id: sender_id , receiver_id: receiver_id).or(where(sender_id:receiver_id,receiver_id: sender_id ))
  }

  def with(current_user)
    sender == current_user ? receiver : sender
  end

  def self.get(sender_id,receiver_id)
    room = Room.between(sender_id,receiver_id).first
    return room if room.present?
    
    create(sender_id: sender_id , receiver_id: receiver_id)
  end
end
