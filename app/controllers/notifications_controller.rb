# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:mark_as_read, :mark_as_unread]

  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page]).per(20)
  end

  def mark_as_read
    @notification.mark_as_read!

    respond_to do |format|
      format.html { redirect_back(fallback_location: notifications_path, notice: "Powiadomienie oznaczone jako przeczytane") }
      format.json { render json: { success: true } }
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@notification) }
    end
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)

    respond_to do |format|
      format.html { redirect_back(fallback_location: notifications_path, notice: "Wszystkie powiadomienia oznaczone jako przeczytane") }
      format.json { render json: { success: true } }
      format.turbo_stream
    end
  end

  def mark_as_unread
    @notification.update(read_at: nil)

    respond_to do |format|
      format.html { redirect_back(fallback_location: notifications_path, notice: "Powiadomienie oznaczone jako nieprzeczytane") }
      format.json { render json: { success: true } }
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@notification) }
    end
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end
