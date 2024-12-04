class Sail < ApplicationRecord
  belongs_to :user, foreign_key: 'employee_id' # Asumiendo que `employee_id` es la FK en Sail
  validate :only_employee_can_create_sale
  has_many :products_sails
  has_many :products, through: :products_sails

  private

  def only_employee_can_create_sale
    if user && !user.has_role?(:employee)
      errors.add(:user, 'must be an employee to create a sale')
    end
  end
end
