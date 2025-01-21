class Product < ApplicationRecord
  # Asociaciones
  belongs_to :category
  has_many :product_sales
  has_many :sales, through: :product_sales
  has_many_attached :images

  # Validaciones
  validates :name, presence: { message: "Ingrese un nombre." }, length: { maximum: 255, message: "El nombre es muy largo."  }
  validates :description, presence: { message: "Ingrese una descripcion." }, length: { maximum: 255, message: "La descripcion es muy larga." }
  validates :price, presence: { message: "Ingrese un precio." }, numericality: { greater_than_or_equal_to: 0, message: "El precio tiene que ser mayor a 0." }
  validates :stock, presence: { message: "Ingrese el stock." }, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "El stock tiene que ser mayor a 0." }
  validates :category, presence: { message: "Seleccione una categoria." }

  # Callbacks
  before_update :set_stock_to_zero_if_deleted

  # Scope
  scope :active, -> { where(deleted_at: nil) }

  # Métodos de instancia
  def name_with_size_and_color
    "#{name} - Talle: #{size || 'N/A'} - Color: #{color || 'N/A'}"
  end

  # Método de eliminación lógica
  def destroy
    update(deleted_at: Time.current)
  end

  # Métodos de búsqueda ransackable
  def self.ransackable_attributes(auth_object = nil)
    [ "name", "category_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "category" ]
  end

  private

  # Callback para manejar el stock cuando se elimina un producto
  def set_stock_to_zero_if_deleted
    if deleted_at_changed? && deleted_at.present?
      self.stock = 0
    end
  end
end
