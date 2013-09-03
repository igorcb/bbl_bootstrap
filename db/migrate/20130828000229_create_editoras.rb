class CreateEditoras < ActiveRecord::Migration
  def change
    create_table :editoras do |t|
      t.string :descricao, limit: 100
      t.string :cidade, limit: 30
      t.string :ano, limit: 4

      t.timestamps
    end
  end
end
