class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  has_many :products_sails
  has_many :sails, through: :products_sails
  scope :active, -> { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end
