class ProductSale < ApplicationRecord
    belongs_to :product
    belongs_to :sale

    validates :product_id, presence: true
    validates :sale_id, presence: true
    validates :amount_sold, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
