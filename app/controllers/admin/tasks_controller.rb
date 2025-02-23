class Admin::TasksController < Admin::ResourcesController
  def index
    set_form_variables

    @q = resource_class.accessible_by(current_ability)
                      .includes(:todo_list, :assignee)
                      .ransack(params[:q])

    @resources = @q.result
                  .page(params[:page])
                  .per(20)
  end

  private

  def resource_class
    Task
  end

  def resource_params
    params.require(:task).permit(
      :name,
      :description,
      :todo_list_id,
      :position,
      :status,
      :due_date,
      :assignee_id
    )
  end

  def set_form_variables
    if current_user.superadmin?
      @todo_lists = TodoList.all.includes(:project)
      @users = User.all
    else
      @todo_lists = TodoList.joins(:project)
                           .where(projects: { company_id: current_user.company_id })
                           .includes(:project)
      @users = current_user.company.users
    end
  end
end
