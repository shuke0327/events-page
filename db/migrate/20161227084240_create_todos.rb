class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.string :content
      t.timestamp :due_at

      t.timestamps
    end
  end
end
