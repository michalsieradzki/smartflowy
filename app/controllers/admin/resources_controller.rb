class Admin::ResourcesController < Admin::BaseController
  helper_method :resource_class, :resource_name
  def index
    @resources = resource_class.accessible_by(current_ability).order(created_at: :desc)
  end

  def new
    @resource = resource_class.new
    set_form_variables
  end

  def create
    @resource = resource_class.new(resource_params)

    if @resource.save
      redirect_to [:admin, resource_class], notice: "#{resource_name} został utworzony"
    else
      set_form_variables
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @resource = resource_class.find(params[:id])
  end

  def update
    @resource = resource_class.find(params[:id])

    if @resource.update(resource_params)
      redirect_to [:admin, resource_class], notice: "#{resource_name} został zaktualizowany"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @resource = resource_class.find(params[:id])
    @resource.destroy

    redirect_to [:admin, resource_class], notice: "#{resource_name} został usunięty", status: :see_other
  end

  private

  def set_form_variables
    return unless resource_class == Team

    @available_users = if current_user.superadmin?
      User.active
    else
      User.active.where(company_id: current_user.company_id)
    end
  end

  def resource_class
    controller_name.classify.constantize
  end

  def resource_name
    resource_class.model_name.human
  end

  def resource_params
    raise NotImplementedError
  end
end
