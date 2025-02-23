class Admin::TodoListsController < Admin::ResourcesController
  def index
    set_form_variables
    @q = resource_class.accessible_by(current_ability)
                      .includes(:project)
                      .ransack(params[:q])

    @resources = @q.result
                  .page(params[:page])
                  .per(20)
  end

  private

  def resource_class
    TodoList
  end

  def resource_params
    params.require(:todo_list).permit(:name, :project_id, :position)
  end


  def set_form_variables
    @projects = if current_user.superadmin?
      Project.all
    else
      Project.where(company_id: current_user.company_id)
    end
  end
end
