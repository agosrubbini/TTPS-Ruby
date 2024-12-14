class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  has_many :products_sails
  has_many :sails, through: :products_sails

  # Scope para productos activos
  scope :active, -> { where(deleted_at: nil) }

  # Elimina lógicamente el producto
  def destroy
    update(deleted_at: Time.current)
  end

  # Callback para manejar el stock
  before_update :set_stock_to_zero_if_deleted

  def name_with_size_and_color
    "#{name} - Talle: #{size || 'N/A'} - Color: #{color || 'N/A'}"
  end

  private

  def set_stock_to_zero_if_deleted
    if deleted_at_changed? && deleted_at.present?
      self.stock = 0
    end
  end
end
