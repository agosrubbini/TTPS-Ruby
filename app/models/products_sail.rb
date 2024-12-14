class ProductsSail < ApplicationRecord
    belongs_to :product
    belongs_to :sail

    validates :amount_sold, numericality: { greater_than: 0 }
    validates :total_amount, numericality: { greater_than: 0 }
end
