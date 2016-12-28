class AddActorsToTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :creator_id, :integer
    add_column :todos, :assignee_id, :integer, nul: true
    add_column :todos, :completor_id, :integer, null: true
    add_column :todos, :completed, :boolean, default: false
    add_column :todos, :soft_deleted, :boolean, default: false
  end
end
