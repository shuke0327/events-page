class CreateJoinTableUserTeam < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :teams, table_name: :memberships do |t|
      t.index [:user_id, :team_id]
      t.index [:team_id, :user_id]
    end
  end
end
