json.id @task.id
json.name @task.name
json.description @task.description
json.status @task.status
json.status_name t("activerecord.attributes.task.statuses.#{@task.status}")
json.due_date @task.due_date ? l(@task.due_date, format: :short) : nil
json.overdue @task.due_date && @task.due_date < Date.today
json.created_at l(@task.created_at, format: :short)

json.project do
  json.id @task.todo_list.project.id
  json.name @task.todo_list.project.name
end

json.todo_list do
  json.id @task.todo_list.id
  json.name @task.todo_list.name
end

json.assignee do
  if @task.assignee
    json.id @task.assignee.id
    json.name @task.assignee.full_name
    json.email @task.assignee.email
  else
    json.nil!
  end
end

json.comments @task.comments.includes(:user).order(created_at: :desc) do |comment|
  json.id comment.id
  json.content comment.content
  json.created_at l(comment.created_at, format: :short)
  json.user do
    json.id comment.user.id
    json.name comment.user.full_name
  end
end
