
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
      can :manage, Project, company_id: user.company_id
      can :manage, TodoList, project: { company_id: user.company_id }
      can :manage, Task, todo_list: { project: { company_id: user.company_id } }
      can :manage, Comment, user: { company_id: user.company_id }
    elsif user.project_manager?
      # Uproszczenie dla testów - używanie hash zamiast bloku
      can :read, Project, company_id: user.company_id
      can :manage, Project, project_manager_id: user.id

      # Kluczowa zmiana - używamy hash zamiast bloku
      can :manage, TodoList, project: { project_manager_id: user.id }

      # Dodaj uprawnienie do nowych todo list
      can :new, TodoList
      can :create, TodoList

      # Pozostałe uprawnienia
      can :read, Task, todo_list: { project: { company_id: user.company_id } }
      can :manage, Task, todo_list: { project: { project_manager_id: user.id } }
      can :manage, Comment, commentable: { todo_list: { project: { project_manager_id: user.id } } }
      can :create, Comment
    else
      # Zwykły użytkownik
      can :read, Project, id: user.project_ids
      can :read, TodoList, project: { id: user.project_ids }
      can :read, Task, todo_list: { project: { id: user.project_ids } }
      can :update, Task, assignee_id: user.id
      can :change_status, Task, assignee_id: user.id
      can :create, Comment
      can :manage, Comment, user_id: user.id
    end
  end
end
