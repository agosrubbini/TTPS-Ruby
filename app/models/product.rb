class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  has_many :products_sails
  has_many :sails, through: :products_sails

  # Callback para manejar el stock
  before_update :set_stock_to_zero_if_deleted

  # Scope para productos activos
  scope :active, -> { where(deleted_at: nil) }


  # Elimina lógicamente el producto
  def destroy
    update(deleted_at: Time.current)
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "category_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "category" ]
  end

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
