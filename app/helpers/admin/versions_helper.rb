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
    return '-' if changes.blank?

    changes.map do |attribute, values|
      old_value, new_value = values
      "#{attribute.humanize}: #{old_value.presence || '(puste)'} → #{new_value.presence || '(puste)'}"
    end.join(', ')
  end

  def version_changes_description(version)
    case version.event
    when 'create'
      'Utworzono nowy obiekt'
    when 'destroy'
      'Usunięto obiekt'
    else
      format_changes(version.changeset)
    end
  end
end
