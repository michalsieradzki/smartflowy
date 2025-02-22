class CreateTodoLists < ActiveRecord::Migration[8.0]
  def change
    create_table :todo_lists do |t|
      t.string :name
      t.references :project, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
