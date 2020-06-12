class GroupMembershipsController < ApplicationController
  def new
    @group_membership = GroupMembership.new
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.find(params[:group_id])
    @events = @group.events
    @group_membership = GroupMembership.new(group_membership_params)
    @group_membership.user = User.find_by(nickname: @group_membership.nickname)
    @group_membership.group = @group
    if @group_membership.save
      redirect_to group_path(@group)
    else
      render "groups/show"
      puts "- ERROR : failed to create member :"
    end
  end

private
  def group_membership_params
    params.require(:group_membership).permit(:nickname)
  end

end
