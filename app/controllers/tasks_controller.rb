class TasksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: [:create, :new]

  def index
    @q = Task.accessible_by(current_ability).ransack(params[:q])
    @tasks = @q.result.includes(todo_list: :project).order(due_date: :asc).page(params[:page]).per(20)
  end

  def show
    @comments = @task.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end
  def new
    @project = Project.find(params[:project_id])
    @todo_list = TodoList.find(params[:todo_list_id])
    authorize! :manage, @todo_list
    @task = Task.new(todo_list: @todo_list)
    @project_members = @project.users

    respond_to do |format|
      format.html { render :new }
    end
  end

  def create
    @todo_list = TodoList.find(params[:todo_list_id])
    authorize! :manage, @todo_list
    @task = @todo_list.tasks.build(task_params)

    if @task.save
      redirect_to project_path(@todo_list.project), notice: "Zadanie zostało utworzone"
    else
      @project = @todo_list.project
      @project_members = @project.users
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @project = @task.todo_list.project
    @project_members = @project.users
  end



  def update
    if @task.update(task_params)
      redirect_to @task, notice: "Zadanie zostało zaktualizowane"
    else
      @comments = @task.comments.includes(:user).order(created_at: :desc)
      @comment = Comment.new
      render :show, status: :unprocessable_entity
    end
  end

  def change_status
    if @task.update(status: params[:status])
      redirect_to @task, notice: "Status zadania został zmieniony"
    else
      redirect_to @task, alert: "Nie udało się zmienić statusu zadania"
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :status, :assignee_id, :due_date, :position)
  end
end
