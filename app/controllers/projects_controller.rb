class ProjectsController < ApplicationController
  before_action :authenticate_user!
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to projects_path, alert: "Nie masz dostępu do tego projektu."
  end
  load_and_authorize_resource

  def index
    @projects = @projects.includes(:project_manager, :users)
                         .order(created_at: :desc)
                         .page(params[:page])
                         .per(10)

    @managed_projects = current_user.managed_projects
                                    .includes(:project_manager, :users)
                                    .order(created_at: :desc)
                                    .page(params[:page])
                                    .per(10) if current_user.project_manager? || current_user.company_admin?
  end

  def show
    @todo_lists = @project.todo_lists.includes(:tasks).order(position: :asc)
  end
end
