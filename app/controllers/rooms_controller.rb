class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user])
    room = Room.get(current_user, user)
    redirect_to room_path(room)
  end

  def show
    @room = Room.find(params[:id])
    @rooms = Room.participating(current_user)
    @message = Message.new
    @messages = @room.messages
  end
end
