class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index 
    @rooms = Room.participating(current_user).order('updated_at DESC')
  end 

  def create
    @user = Product.find(params[:format]).shop.user
    @room = Room.get(current_user.id, user.id)
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    # @message = Message.new
    # @messages = @room.messages.includes(:user)
  end
end
