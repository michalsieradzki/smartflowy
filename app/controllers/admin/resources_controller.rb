class Admin::ResourcesController < Admin::BaseController
  helper_method :resource_class, :resource_name
  def index
    @q = resource_class.ransack(params[:q])
    @resources = @q.result(distinct: true)
                  .accessible_by(current_ability)
                  .order(created_at: :desc)
                  .page(params[:page])
                  .per(20)
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
    @available_users = if resource_class == Project
      if current_user.superadmin?
        User.active
      else
        User.active.where(company_id: current_user.company_id)
      end
    elsif resource_class == User
      @companies = Company.all if current_user.superadmin?
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
