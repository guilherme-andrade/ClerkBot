class RemoveKeyAndTypeFromIntents < ActiveRecord::Migration[5.1]
  def change
    remove_column :intents, :type, :string
    remove_column :intents, :key, :string
  end
end
