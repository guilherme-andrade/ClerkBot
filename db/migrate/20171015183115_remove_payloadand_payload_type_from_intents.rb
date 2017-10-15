class RemovePayloadandPayloadTypeFromIntents < ActiveRecord::Migration[5.1]
  def change
    remove_column :intents, :payload, :string
    remove_column :intents, :payload_type, :string
  end
end
