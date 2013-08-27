class Autor < ActiveRecord::Base
  validates :descricao, presence: true, length: { maximum: 100 }
  validates :cutter, presence: true, length: { maximum: 10 }
end
