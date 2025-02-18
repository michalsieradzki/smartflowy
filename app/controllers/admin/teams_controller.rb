class Admin::TeamsController < Admin::ResourcesController
  def new
    @resource = resource_class.new
    @available_users = available_users_for_select
  end

  def edit
    @resource = resource_class.find(params[:id])
    @available_users = available_users_for_select
  end

  private

  def available_users_for_select
    scope = User.active
    if current_user.superadmin?
      scope.all
    else
      scope.where(company_id: current_user.company_id)
    end
  end

  def resource_params
    params.require(:team).permit(:name, :description, :company_id, user_ids: [])
  end
end
