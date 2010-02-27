class ChatController < ApplicationController
  def index
    render :layout => false
  end

  def send_message
    render :juggernaut do |page|
      page["#chat_data"].prepend "<li>#{h params[:chat_input]}</li>"
    end
    render :nothing => true
  end
end
