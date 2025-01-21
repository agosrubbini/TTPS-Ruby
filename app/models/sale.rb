class Sale < ApplicationRecord
  # Asociaciones
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  has_many :product_sales
  has_many :products, through: :product_sales

  # Validaciones
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :completed_at, presence: true

  # Acepta atributos anidados para product_sales
  accepts_nested_attributes_for :product_sales,
    allow_destroy: true,
    reject_if: :all_blank

  # Métodos de instancia
  def calculate_total(cart)
    cart.sum do |product_id, amount|
      product = Product.find(product_id)
      product.price * amount
    end
  end

  # Método para crear la venta y actualizar el stock
  def create_sale_and_update_stock(cart)
    self.total_amount = calculate_total(cart)

    if save
      cart.each do |product_id, amount|
        product = Product.find(product_id)
        total_price = product.price * amount

        # Crear la relación en ProductSale
        ProductSale.create!(
          sale: self,
          product: product,
          amount_sold: amount,
          total_amount: total_price
        )

        # Actualizar el stock del producto
        product.update!(stock: product.stock - amount)
      end
    end
  end

  # Método para cancelar la venta y restaurar el stock
  def cancel_sale
    product_sales.each do |product_sale|
      product = product_sale.product
      product.update!(stock: product.stock + product_sale.amount_sold)
    end
    update(is_deleted: true)
  end
end
