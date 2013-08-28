class Editora < ActiveRecord::Base
	validates :descricao, presence: true, length: {maximum: 100}
  validates :cidade, length: {maximum: 30}
  validates :ano, length: {maximum: 4}

end
