class Admin::UsersController < Admin::ResourcesController
  def destroy
    @resource = resource_class.find(params[:id])
    @resource.disable!

    redirect_to [:admin, resource_class],
                notice: "Użytkownik #{@resource.full_name} został dezaktywowany",
                status: :see_other
  end
  private

  def resource_params
    permitted_params = [:email, :password, :first_name, :last_name,
                       :phone, :position, :role]
    permitted_params << :company_id if current_user.superadmin?

    params.require(:user).permit(permitted_params)
  end
end
