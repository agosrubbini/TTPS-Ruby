class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  has_many :product_sales
  has_many :sales, through: :product_sales

  validates :name, presence: { message: "Ingrese un nombre." }, length: { maximum: 255, message: "El nombre es muy largo."  }
  validates :description, presence: { message: "Ingrese una descripcion." }, length: { maximum: 255, message: "La descripcion es muy larga." }
  validates :price, presence: { message: "Ingrese un precio." }, numericality: { greater_than_or_equal_to: 0, message: "El precio tiene que ser mayor a 0." }
  validates :stock, presence: { message: "Ingrese el stock." }, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "El stock tiene que ser mayor a 0." }
  validates :category, presence: { message: "Seleccione una categoria." }

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
