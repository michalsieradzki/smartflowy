class Admin::VersionsController < Admin::ResourcesController
  def index
    @resources = resource_class.includes(:item)
                             .accessible_by(current_ability)
                             .order(created_at: :desc)
                             .page(params[:page])
                             .per(20)
  end

  def resource_class
    PaperTrail::Version
  end
  private

  def set_form_variables
  end

  def resource_params
    {}
  end
end
