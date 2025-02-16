class Admin::UsersController < Admin::BaseController
  def index
    @users = User.accessible_by(current_ability).order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.company = current_user.company unless current_user.superadmin?

    if @user.save
      redirect_to admin_users_path, notice: 'Użytkownik został utworzony'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'Użytkownik został zaktualizowany'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    permitted_params = [:email, :password, :first_name, :last_name,
                       :phone, :position, :role]
    permitted_params << :company_id if current_user.superadmin?

    params.require(:user).permit(permitted_params)
  end
end
