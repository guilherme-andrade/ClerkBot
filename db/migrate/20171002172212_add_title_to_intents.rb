class AddTitleToIntents < ActiveRecord::Migration[5.1]
  def change
    add_column :intents, :title, :string
  end
end
