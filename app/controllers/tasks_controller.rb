class TasksController < ApplicationController
  before_action :set_team, only: [:new, :create]
  before_action :set_task, only: [:edit, :update]

  def index
    # RESOLVER ESTA MERDA EM ALGUM MOMENTO

    # IF USER = MANAGER
    # @user = current_user
    # @team = Team.find(@user)
    # @team_member = TeamMember.where(team_id: @team, user_id: @user)

    @tasks = policy_scope(Task)
    authorize @tasks
    # ELSE
    # @tasks = policy_scope(Task).where(user: current_user)
    # binding.pry
  end

  def new
    @task = Task.new
    @team_members = TeamMember.where(team_id: @team.id, admin: false)
    authorize @task
  end

  def create
    @task = Task.new(task_params)
    @task.manager = current_user
    @task.team_id = @team.id
    authorize @task
    if @task.save
      redirect_to task_path(@task)
    else
      render 'tasks/new', status: :unprocessable_entity
    end
  end

  def edit
    authorize @task
  end

  def update
    authorize @task
    @task.update(task_params)
    redirect_to task_path(@task), notice: "Task was updated!"
  end

  def show
    @task = Task.find(params[:id])
    authorize @task
  end

  def destroy
    authorize @task
    @task.destroy
    redirect_to tasks_path, status: :see_other
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :completed, :deadline, :member_id, :team_id)
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_task
    @task = Task.find(params[:id])
  end

end
