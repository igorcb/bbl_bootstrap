class CreateClassificacoes < ActiveRecord::Migration
  def change
    create_table :classificacoes do |t|
      t.string :cdd, limit: 10
      t.string :descricao, limit: 100, null: false

      t.timestamps
    end
  end
end
