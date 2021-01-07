class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    my_message = ApplicationController.render(
      partial: "messages/my_message",
      locals: {message: message}
    )

    other_message = ApplicationController.render(
      partial: "messages/other_message",
      locals: {message: message}
    )
  
    ActionCable.server.broadcast "chat_channel_#{message[:room_id]}" , {my_message:my_message,other_message:other_message, message: message} 

  end
end
