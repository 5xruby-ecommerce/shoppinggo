class MessagesController < ApplicationController
  before_action :message_params , only: [:create]

  def create
    room = Room.find(params[:room_id])
    @message = current_user.messages.new(message_params)
    @message[:room_id] = room.id

    if @message.save
      MessageBroadcastJob.perform_later(@message)
    end

  end

  private

  def message_params 
    params.require(:message).permit(:content)
  end
end
