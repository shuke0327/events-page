class CreateAccesses < ActiveRecord::Migration[5.0]
  def change
    create_table :accesses do |t|
      t.integer :user_id
      t.integer :project_id
    end
    add_index :accesses, :user_id
    add_index :accesses, :project_id
    add_index :accesses, [:user_id, :project_id], unique: true
  end
end
