class CreateIntents < ActiveRecord::Migration[5.1]
  def change
    create_table :intents do |t|
      t.string :type
      t.string :key
      t.references :intent, foreign_key: true

      t.timestamps
    end
  end
end
