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

  def resource_filters
    case resource_class.name
    when 'User'
      [
        { attribute: :email_cont, type: :string, width: '2' },
        { attribute: :first_name_cont, type: :string, width: '2' },
        { attribute: :last_name_cont, type: :string, width: '2' },
        { attribute: :role_eq, type: :select, width: '2',
          collection: User.roles.map { |k,v| [User.human_attribute_name(k), v] } },
        { attribute: :created_at, type: :date_range, width: '3' }
      ]
    when 'Team'
      [
        { attribute: :name_cont, type: :string, width: '3' },
        { attribute: :description_cont, type: :string, width: '4' },
        { attribute: :created_at, type: :date_range, width: '3' }
      ]
    when 'PaperTrail::Version'
      [
        { attribute: :item_type_eq, type: :select, width: '2',
          collection: PaperTrail::Version.distinct.pluck(:item_type) },
        { attribute: :event_eq, type: :select, width: '2',
          collection: %w[create update destroy] },
        { attribute: :created_at, type: :date_range, width: '3' }
      ]
    else
      []
    end
  end
end
