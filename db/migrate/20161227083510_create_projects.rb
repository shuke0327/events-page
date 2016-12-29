class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.integer :team_id
      t.timestamps
    end
    add_index :projects, :team_id
  end
end
