class Sail < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_many :products_sails
  has_many :products, through: :products_sails

  accepts_nested_attributes_for :products_sails, 
    allow_destroy: true, 
    reject_if: :all_blank

  validates :completed_at, presence: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  
  def destroy
    update(is_deleted: true)
  end

end
