module Admin::CommentsHelper
  def comment_commentable_link(comment)
    case comment.commentable_type
    when 'Task'
      link_to "Zadanie: #{comment.commentable.name}",
              edit_admin_task_path(comment.commentable)
    else
      "#{comment.commentable_type}: #{comment.commentable_id}"
    end
  end
end
