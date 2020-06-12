class MessagesController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    @message = Message.new(message_params)
    @message.group = @group
    @message.user = current_user
    p @message.valid?
    p @message
    if @message.save
      redirect_to group_path(@group)
    else
      render "groups/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
