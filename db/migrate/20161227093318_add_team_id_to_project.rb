class AddTeamIdToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :team_id, :integer
  end
  add_index :projects, :team_id
end
