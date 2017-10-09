class AddAttributesToIntents < ActiveRecord::Migration[5.1]
  def change
    add_column :intents, :subtitle, :string
    add_column :intents, :image, :string
    add_column :intents, :url, :string
  end
end
