class Admin::BaseController < ApplicationController
  before_action :check_admin_access

  layout 'admin'

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private

  def check_admin_access
    authorize! :access, :admin_panel
  end
end
