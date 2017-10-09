class AddPayloadAndContentTypeToIntents < ActiveRecord::Migration[5.1]
  def change
    add_column :intents, :payload, :string
    add_column :intents, :content_type, :string
  end
end
