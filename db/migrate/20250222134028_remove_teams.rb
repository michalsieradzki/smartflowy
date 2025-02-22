class RemoveTeams < ActiveRecord::Migration[8.0]
  def up
    remove_reference :projects, :team, foreign_key: true
    drop_table :team_memberships
    drop_table :teams
  end

  def down
    create_table :teams do |t|
      t.string :name
      t.text :description
      t.references :company, null: false, foreign_key: true
      t.timestamps
    end

    create_table :team_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :role
      t.timestamps
    end

    add_reference :projects, :team, foreign_key: true
  end
end
