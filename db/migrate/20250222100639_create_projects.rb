class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.references :team, null: false, foreign_key: true
      t.references :project_manager, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
