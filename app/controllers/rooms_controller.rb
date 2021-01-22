class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user])
    room = Room.get(current_user, user)
    # redirect_to room_path(room)
    @room = room
    @message = Message.new
    @messages = @room.messages
  end

  def show
    @room = Room.find(params[:id])
    @message = Message.new
    @messages = @room.messages
  end
end
