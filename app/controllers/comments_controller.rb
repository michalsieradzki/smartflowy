class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :task
  load_and_authorize_resource :comment, through: :task, shallow: true

  def create
    @comment.user = current_user
    @comment.commentable = @task

    if @comment.save
      redirect_to @task, notice: "Komentarz został dodany"
    else
      redirect_to @task, alert: "Nie udało się dodać komentarza: #{@comment.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.commentable, notice: "Komentarz został usunięty"
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
