class RoomsController < ApplicationController
  before_action :authenticate_user!


  def create
    user = User.find(params[:with])
    room = Room.get(current_user.id, user.id)
    # redirect_to room_path(room)
    @room = room
    @rooms = Room.participating(current_user)
    @message = Message.new
    @messages = @room.messages
  end

  def show
    @room = Room.find(params[:id])
    @message = Message.new
    @messages = @room.messages
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
  end
end
