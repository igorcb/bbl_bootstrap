class Livro < ActiveRecord::Base
	belongs_to :casa
  belongs_to :autor
  belongs_to :editora
  belongs_to :local
  belongs_to :assunto
  belongs_to :classificacao

  validates :casa_id, presence:true
  validates :autor_id, presence:true
  validates :editora_id, presence:true
  validates :local_id, presence:true
  validates :assunto_id, presence:true
  validates :classificacao_id, presence:true
  validates :num_tombo, presence:true, length: {maximum: 10}
  validates :descricao, presence:true, length: {maximum: 100}
  validates :cutter, presence:true, length: {maximum: 25}
  validates :isbn, length: {maximum: 30}
  validates :edicao, length: {maximum: 10}
  validates :ano, length: {maximum: 4}
  validates :paginas, length: {maximum: 25}
  validates :localizacao, length: {maximum: 25}

  def proxtombo
    livro = Livro.order('id DESC').limit(1)
    unless livro.empty?
      proxtombo = livro[0].num_tombo.to_i + 1 
    else
      proxtombo = 1 
    end
  end

end
