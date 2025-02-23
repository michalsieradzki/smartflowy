class Admin::ProjectsController < Admin::ResourcesController
  def index
    set_form_variables

    @q = resource_class.accessible_by(current_ability)
                      .includes(:project_manager, :users)
                      .ransack(params[:q])

    @resources = @q.result
                  .page(params[:page])
                  .per(20)
  end

  private


  def set_form_variables
    if current_user.superadmin?
      @users = User.active
      @project_managers = User.where(role: [:project_manager, :company_admin])
    else
      @users = User.active.where(company_id: current_user.company_id)
      @project_managers = User.where(company_id: current_user.company_id)
                            .where(role: [:project_manager, :company_admin])
    end
  end

  def resource_params
    params.require(:project).permit(
      :name,
      :description,
      :project_manager_id,
      :company_id,
      attachments: [],
      user_ids: []
    )
  end
end
