class CreateAutores < ActiveRecord::Migration
  def change
    create_table :autores do |t|
      t.string :descricao, limit: 100, null: false
      t.string :cutter, limit: 10, null: false

      t.timestamps
    end
  end
end
