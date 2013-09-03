class CreateCasas < ActiveRecord::Migration
  def change
    create_table :casas do |t|
      t.string :descricao, limit: 100, null: false

      t.timestamps
    end
  end
end
