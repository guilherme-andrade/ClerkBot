class AddTagToIntents < ActiveRecord::Migration[5.1]
  def change
    add_column :intents, :tag, :string
  end
end
