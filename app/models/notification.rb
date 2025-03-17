# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User', optional: true
  belongs_to :notifiable, polymorphic: true, optional: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc).limit(10) }

  # Typy powiadomień
  enum :notification_type, {
    task_assigned: 0,
    task_deadline: 1,
    task_comment: 2,
    task_status_changed: 3,
    project_assigned: 4,
    project_update: 5
  }

  def read?
    read_at.present?
  end

  def mark_as_read!
    update(read_at: Time.current)
  end

  # Metoda do tworzenia powiadomienia o przypisaniu zadania
  def self.notify_task_assigned(task, actor)
    return unless task.assignee

    create(
      recipient: task.assignee,
      actor: actor,
      notifiable: task,
      notification_type: :task_assigned,
      message: "#{actor.full_name} przypisał(a) Cię do zadania #{task.name}"
    )
  end

  # Metoda do tworzenia powiadomienia o komentarzu do zadania
  def self.notify_task_comment(comment, actor)
    task = comment.commentable
    return unless task.is_a?(Task)

    # Powiadom osobę przypisaną do zadania (jeśli nie jest autorem komentarza)
    if task.assignee && task.assignee != actor
      create(
        recipient: task.assignee,
        actor: actor,
        notifiable: comment,
        notification_type: :task_comment,
        message: "#{actor.full_name} skomentował(a) zadanie #{task.name}"
      )
    end

    # Powiadom kierownika projektu (jeśli nie jest autorem komentarza)
    project_manager = task.todo_list.project.project_manager
    if project_manager && project_manager != actor && project_manager != task.assignee
      create(
        recipient: project_manager,
        actor: actor,
        notifiable: comment,
        notification_type: :task_comment,
        message: "#{actor.full_name} skomentował(a) zadanie #{task.name} w Twoim projekcie"
      )
    end
  end

  # Metoda do tworzenia powiadomienia o zmianie statusu zadania
  def self.notify_task_status_changed(task, actor)
    status_name = I18n.t("activerecord.attributes.task.statuses.#{task.status}")

    # Powiadom osobę przypisaną do zadania
    if task.assignee && task.assignee != actor
      create(
        recipient: task.assignee,
        actor: actor,
        notifiable: task,
        notification_type: :task_status_changed,
        message: "#{actor.full_name} zmienił(a) status zadania #{task.name} na #{status_name}"
      )
    end

    # Powiadom kierownika projektu
    project_manager = task.todo_list.project.project_manager
    if project_manager && project_manager != actor && project_manager != task.assignee
      create(
        recipient: project_manager,
        actor: actor,
        notifiable: task,
        notification_type: :task_status_changed,
        message: "#{actor.full_name} zmienił(a) status zadania #{task.name} na #{status_name}"
      )
    end
  end
end
