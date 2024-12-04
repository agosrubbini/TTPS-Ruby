class ProductsSail < ApplicationRecord
    belongs_to :product
    belongs_to :sail

    validates :amount_sold, numericality: { greater_than_or_equal_to: 0 }
    validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
end
