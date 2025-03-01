module TasksHelper
  def task_status_color(status)
    case status.to_s
    when 'pending' then 'secondary'
    when 'in_progress' then 'primary'
    when 'completed' then 'success'
    when 'on_hold' then 'warning'
    else 'secondary'
    end
  end

  def task_status_icon(status)
    case status.to_s
    when 'pending' then 'bi-hourglass'
    when 'in_progress' then 'bi-play-fill'
    when 'completed' then 'bi-check-circle-fill'
    when 'on_hold' then 'bi-pause-fill'
    else 'bi-question-circle'
    end
  end
end
