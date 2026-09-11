class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[show edit update destroy]

  def index
    @groups = current_user.groups
  end

  def show
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      GroupUser.create!(
        group: @group,
        user: current_user
      )

      redirect_to @group
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to @group
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy

    redirect_to groups_path, notice: "Group deleted."
  end

  def join
  end

  def join_create
    @group = Group.find_by(
      invite_code: params[:invite_code].to_s.upcase
    )

    if @group.nil?
      flash.now[:alert] = "Group not found. Check the invite code."
      render :join, status: :unprocessable_entity
      return
    end

    unless current_user.groups.include?(@group)
      GroupUser.create!(
        group: @group,
        user: current_user
      )
    end

    redirect_to @group
  end

  private

  def set_group
    @group = current_user.groups.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
