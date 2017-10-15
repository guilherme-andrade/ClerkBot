class AddPayloadToIntents < ActiveRecord::Migration[5.1]
  def change
    add_column :intents, :payload, :string
    add_index :intents, :payload, unique: true
  end
end
