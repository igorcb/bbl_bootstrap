class CreateAssunto < ActiveRecord::Migration
  def change
    create_table :assuntos do |t|
    	t.string :descricao, limit: 100

      t.timestamps
    end
  end
end
