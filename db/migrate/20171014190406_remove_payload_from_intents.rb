class RemovePayloadFromIntents < ActiveRecord::Migration[5.1]
  def change
    remove_column :intents, :payload, :string
  end
end
