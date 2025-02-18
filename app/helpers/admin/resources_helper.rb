module Admin::ResourcesHelper
  def resource_columns
    case resource_class.name
    when 'User'
      %i[full_name email role company position disabled]
    when 'Team'
      %i[name company description created_at]
    else
      resource_class.column_names - %w[id updated_at]
    end
  end

  def resource_value(resource, column)
    value = resource.send(column)
    case value
    when Time
      l(value, format: :short)
    when true
      'Tak'
    when false
      'Nie'
    when Company
      value.name
    else
      case column
      when :role
        resource.role.humanize
      else
        value.to_s
      end
    end
  end
end
