class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def show
    @messages = Message.where(group_id: @group)
    @message = Message.new
    @users = GroupMembership.where(group_id: @group)
    @events = Event.where(group_id: @group)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
     if @group.save
      redirect_to group_path(@group)
    else
      puts "- ERROR : failed to create group :"
      p @group
      render 'new'
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group)
    else
      puts "- ERROR : failed to update group :"
      p @group
      render "edit"
    end
  end

  def destroy
    @group.destroy
    redirect_to dashboard_path
  end

private
  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:title, :avatar_file)
  end
end