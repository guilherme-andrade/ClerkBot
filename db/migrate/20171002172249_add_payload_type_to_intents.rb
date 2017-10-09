class AddPayloadTypeToIntents < ActiveRecord::Migration[5.1]
  def change
    add_column :intents, :payload_type, :string
  end
end
