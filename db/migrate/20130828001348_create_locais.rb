class CreateLocais < ActiveRecord::Migration
  def change
    create_table :locais do |t|
      t.string :descricao

      t.timestamps
    end
  end
end
