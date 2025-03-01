# app/controllers/todo_lists_controller.rb
class TodoListsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project, only: [:new, :create]
  load_and_authorize_resource :todo_list, through: :project, shallow: true

  def show
    @tasks = @todo_list.tasks.includes(:assignee).order(position: :asc)
  end

  def new
    @todo_list = @project.todo_lists.build
  end

  def create
    @todo_list = @project.todo_lists.build(todo_list_params)

    if @todo_list.save
      redirect_to project_path(@project), notice: "Lista zadań została utworzona"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def todo_list_params
    params.require(:todo_list).permit(:name, :position)
  end
end
