class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = Room.participating(current_user)
  end


  def create
    @user = User.find(params[:user])
    @room = Room.get(current_user.id, @user.id)
    redirect_to room_path(@room.id)
  end

  def show

    @room = Room.find(params[:id])
    @rooms = Room.participating(current_user)
    @message = Message.new
    @messages = @room.messages
  end
end
