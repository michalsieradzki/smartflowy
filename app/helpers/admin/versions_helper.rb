module Admin::VersionsHelper
  def version_badge_class(event)
    case event
    when 'create' then 'success'
    when 'update' then 'info'
    when 'destroy' then 'danger'
    else 'secondary'
    end
  end

  def format_changes(changes)
    changes.map do |attribute, values|
      old_value, new_value = values
      "#{attribute.humanize}: #{old_value.presence || '(puste)'} → #{new_value.presence || '(puste)'}"
    end.join(', ')
  end
end
