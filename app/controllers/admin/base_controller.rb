class Admin::BaseController < ApplicationController
  before_action :check_admin_access
  layout 'admin'

  private

  def require_admin
    unless current_user&.superadmin? || current_user&.company_admin?
      redirect_to root_path, alert: 'Brak dostępu'
    end
  end

  def check_admin_access
    authorize! :access, :admin_panel
  end
end
