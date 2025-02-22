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
    @users = current_user.company.users
    @project_managers = @users.where(role: [:project_manager, :company_admin])
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
