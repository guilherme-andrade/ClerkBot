class AddReferenceAndOptionTypesToIntents < ActiveRecord::Migration[5.1]
  def change
    add_column :intents, :reference, :string
    add_index :intents, :reference
    add_column :intents, :option_types, :string
  end
end
