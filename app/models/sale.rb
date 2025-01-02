class Sale < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  has_many :product_sales
  has_many :products, through: :product_sales

  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :completed_at, presence: true

  accepts_nested_attributes_for :product_sales,
    allow_destroy: true,
    reject_if: :all_blank



  def destroy
    update(is_deleted: true)
  end
end
