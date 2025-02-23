class Admin::CommentsController < Admin::ResourcesController
  def index
    set_form_variables
    @q = resource_class.accessible_by(current_ability)
                      .includes(:user, :commentable)
                      .ransack(params[:q])

    @resources = @q.result
                  .page(params[:page])
                  .per(20)
  end

  private

  def resource_class
    Comment
  end
  def set_form_variables
    @users = if current_user.superadmin?
      User.all
    else
      current_user.company.users
    end
  end
  def resource_params
    params.require(:comment).permit(:content, :user_id, :commentable_type, :commentable_id)
  end
end
