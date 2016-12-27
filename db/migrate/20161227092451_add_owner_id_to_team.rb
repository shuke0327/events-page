class AddOwnerIdToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :owner_id, :integer
  end
end
