class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :recipient, foreign_key: { to_table: :users }
      t.references :actor, foreign_key: { to_table: :users }, null: true
      t.references :notifiable, polymorphic: true, null: true
      t.string :message
      t.integer :notification_type
      t.datetime :read_at, null: true

      t.timestamps
    end

    add_index :notifications, [:recipient_id, :read_at]
  end
end
