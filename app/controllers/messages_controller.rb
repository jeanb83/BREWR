class MessagesController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    @events = @group.events
    @message = Message.new(message_params)
    @message.group = @group
    @message.user = current_user
    if @message.save
      Notification.new_group_message(@message)
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
