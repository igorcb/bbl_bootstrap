class CreateLivros < ActiveRecord::Migration
  def change
    create_table :livros do |t|
      t.integer :casa_id, null: false
      t.integer :autor_id, null: false
      t.integer :editora_id, null: false
      t.integer :local_id, null: false
      t.integer :assunto_id, null: false
      t.integer :classificacao_id, null: false
      t.string :num_tombo, limit: 10, null: false
      t.string :descricao, limit: 100, null: false
      t.string :cutter, limit: 25, null: false
      t.string :isbn, limit: 30
      t.string :edicao, limit: 10
      t.string :ano, limit: 4
      t.string :paginas, limit: 25
      t.string :localizacao, limit: 25

      t.timestamps
    end
  end
end
