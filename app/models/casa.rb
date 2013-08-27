class Casa < ActiveRecord::Base
  validates :descricao, presence: true, length: { maximum: 50 }
end
