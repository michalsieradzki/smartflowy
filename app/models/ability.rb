class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    if user.superadmin?
      can :manage, :all
    elsif user.company_admin?
      can :read, PaperTrail::Version, item: { company_id: user.company_id }
      can :access, :admin_panel
      can :manage, User, company_id: user.company_id
      can :manage, Team, company_id: user.company_id
    else
      cannot :access, :admin_panel
    end
  end
end
