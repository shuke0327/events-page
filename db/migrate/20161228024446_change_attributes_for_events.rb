class ChangeAttributesForEvents < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :ancestor_class, :ancestor_type
    rename_column :events, :invoke_item_class, :invoke_item_type
  end
end
