class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :integer, null: false, default: 3
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :position, :string
    add_column :users, :timezone, :string
    add_column :users, :last_active_at, :datetime
    add_column :users, :disabled, :boolean, default: false, null: false
  end
end
