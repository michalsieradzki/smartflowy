module Admin::TasksHelper
  def task_status_color(status)
    case status
    when 'pending' then 'secondary'
    when 'in_progress' then 'primary'
    when 'completed' then 'success'
    when 'on_hold' then 'warning'
    end
  end
end
