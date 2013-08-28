class Classificacao < ActiveRecord::Base
	validates :cdd, presence: true, length: {maximum: 10}
	validates :descricao, presence: true, length: {maximum: 100}
	
end
