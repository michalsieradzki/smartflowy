class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.references :todo_list, null: false, foreign_key: true
      t.integer :position
      t.integer :status
      t.datetime :due_date
      t.references :assignee, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
