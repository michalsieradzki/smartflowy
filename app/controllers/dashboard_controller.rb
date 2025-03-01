class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @my_projects = current_user.projects.includes(:project_manager).order(created_at: :desc).limit(5)
    @managed_projects = current_user.managed_projects
                                  .includes(:project_manager)
                                  .order(created_at: :desc)
                                  .limit(5) if current_user.project_manager? || current_user.company_admin?

    @my_tasks = Task.accessible_by(current_ability)
                   .where(assignee_id: current_user.id)
                   .where.not(status: :completed)
                   .includes(todo_list: :project)
                   .order(due_date: :asc)
                   .limit(10)

    @upcoming_deadlines = @my_tasks.where("due_date >= ? AND due_date <= ?", Date.today, 7.days.from_now)

    @tasks_by_status = Task.accessible_by(current_ability)
                           .where(assignee_id: current_user.id)
                           .group(:status)
                           .count
  end
end
