class Local < ActiveRecord::Base
	validates :descricao, presence: true, length: {maximum: 100}
end
