class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :ancestor_id
      t.string  :ancestor_type #project, weekly_report, or calendar
      t.integer :actor_id
      t.string  :action_desc
      t.string  :action_label
      t.string  :action_type, default: "common"
      t.string  :invoke_item_type
      t.integer :invoke_item_id
      t.string  :extentions
      t.timestamps
    end
  end
end
