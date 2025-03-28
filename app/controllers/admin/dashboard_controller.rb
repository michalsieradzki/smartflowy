class Admin::DashboardController < Admin::BaseController
  def index
    @users_count = User.accessible_by(current_ability).count
    @projects_count = Project.accessible_by(current_ability).count
    @recent_users = User.accessible_by(current_ability).order(created_at: :desc).limit(5)
  end
end
