class MessagesController < ApplicationController
  before_action :require_user

  def create
    @message = Message.new(message_params)
    @message.chef = current_chef
    if @message.save
      ActionCable.server.broadcast 'chatroom_channel', message: render_message(@message), chef: @message.chef.chefname
    else
      render 'chatrooms/show'
    end
  end

  def render_message(message)
    render(partial: 'message', locals: { message: message })
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
