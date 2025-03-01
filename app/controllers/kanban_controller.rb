class KanbanController < ApplicationController
  before_action :authenticate_user!

  def index
    # Domyślnie pokazuj wszystkie projekty użytkownika
    @projects = current_user.projects.includes(:project_manager)

    # Jeśli użytkownik jest kierownikiem projektu, dodaj też projekty, którymi zarządza
    if current_user.project_manager? || current_user.company_admin?
      @projects = @projects.or(current_user.managed_projects)
    end

    # Filtrowanie po projekcie, jeśli parametr został przekazany
    if params[:project_id].present?
      @selected_project = Project.accessible_by(current_ability).find_by(id: params[:project_id])
    end

    # Pobierz zadania do wyświetlenia na tablicy Kanban
    if current_user.superadmin? || current_user.company_admin?
      # Administratorzy widzą wszystkie zadania dostępne dla nich
      @tasks = Task.accessible_by(current_ability).includes([:assignee, todo_list: :project])
    elsif current_user.project_manager?
      # Kierownicy projektu widzą zadania z zarządzanych projektów
      managed_project_ids = current_user.managed_projects.pluck(:id)
      @tasks = Task.includes([:assignee, todo_list: :project])
                  .where(todo_list: { project_id: managed_project_ids })
    else
      # Zwykli użytkownicy widzą zadania z projektów, w których uczestniczą
      # oraz zadania, które są do nich przypisane
      project_tasks = Task.includes([:assignee, todo_list: :project])
                        .where(todo_list: { project_id: current_user.project_ids })
      assigned_tasks = Task.includes([:assignee, todo_list: :project])
                         .where(assignee_id: current_user.id)

      @tasks = project_tasks.or(assigned_tasks)
    end

    # Filtruj po projekcie, jeśli został wybrany
    @tasks = @tasks.where(todo_list: { project_id: @selected_project.id }) if @selected_project.present?

    # Pogrupuj zadania według statusu
    @tasks_by_status = {
      'pending' => @tasks.where(status: :pending).order(due_date: :asc, created_at: :desc),
      'in_progress' => @tasks.where(status: :in_progress).order(due_date: :asc, created_at: :desc),
      'on_hold' => @tasks.where(status: :on_hold).order(due_date: :asc, created_at: :desc),
      'completed' => @tasks.where(status: :completed).order(due_date: :asc, created_at: :desc)
    }
  end

  def update_status
    @task = Task.accessible_by(current_ability).find(params[:task_id])

    authorize! :change_status, @task

    if @task.update(status: params[:status])
      respond_to do |format|
        format.json { render json: { success: true } }
        format.html { redirect_to kanban_index_path }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false, errors: @task.errors.full_messages }, status: :unprocessable_entity }
        format.html { redirect_to kanban_index_path, alert: "Nie udało się zmienić statusu zadania" }
      end
    end
  rescue CanCan::AccessDenied
    respond_to do |format|
      format.json { render json: { success: false, errors: ["Nie masz uprawnień do zmiany statusu tego zadania"] }, status: :forbidden }
      format.html { redirect_to kanban_index_path, alert: "Nie masz uprawnień do zmiany statusu tego zadania" }
    end
  end
end
