module RoomsHelper
  def set_chatrooms
    if current_user.present?
      if Room.participating(current_user).present?
        @rooms = Room.participating(current_user)
        render @rooms
      end
    end
  end
end
