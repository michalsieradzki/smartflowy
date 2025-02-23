class Admin::ResourcesController < Admin::BaseController
  helper_method :resource_class, :resource_name
  before_action :set_resource, only: [:edit, :update, :destroy]
  before_action :set_form_variables, only: [:index, :new, :create, :edit, :update]

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
  end

  def create
    @resource = resource_class.new(resource_params)

    if @resource.save
      redirect_to [:admin, resource_class], notice: "#{resource_name} został utworzony"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @resource.update(resource_params)
      redirect_to [:admin, resource_class], notice: "#{resource_name} został zaktualizowany"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @resource.destroy
    redirect_to [:admin, resource_class], notice: "#{resource_name} został usunięty", status: :see_other
  end

  private

  def set_resource
    @resource = resource_class.find(params[:id])
  end

  def set_form_variables
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
