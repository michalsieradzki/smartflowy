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

    respond_to do |format|
      format.html
      format.json
    end
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
      if @task.assignee.present?
        Notification.notify_task_assigned(@task, current_user)
      end

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
    previous_assignee_id = @task.assignee_id
    previous_status = @task.status

    if @task.update(task_params)
      if previous_assignee_id != @task.assignee_id && @task.assignee.present?
        Notification.notify_task_assigned(@task, current_user)
      end

      if previous_status != @task.status
        Notification.notify_task_status_changed(@task, current_user)
      end

      respond_to do |format|
        format.html { redirect_to @task, notice: "Zadanie zostało zaktualizowane" }
        format.json { render json: { success: true } }
      end
    else
      respond_to do |format|
        format.html do
          @comments = @task.comments.includes(:user).order(created_at: :desc)
          @comment = Comment.new
          render :show, status: :unprocessable_entity
        end
        format.json { render json: { success: false, errors: @task.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def change_status
    if @task.update(status: params[:status])
      Notification.notify_task_status_changed(@task, current_user)

      respond_to do |format|
        format.html { redirect_to @task, notice: "Status zadania został zmieniony" }
        format.json { render json: { success: true } }
      end
    else
      respond_to do |format|
        format.html { redirect_to @task, alert: "Nie udało się zmienić statusu zadania" }
        format.json { render json: { success: false, errors: @task.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :status, :assignee_id, :due_date, :position)
  end
end
