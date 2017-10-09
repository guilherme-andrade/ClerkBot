class AddMessageToIntent < ActiveRecord::Migration[5.1]
  def change
    add_column :intents, :message, :text
  end
end
