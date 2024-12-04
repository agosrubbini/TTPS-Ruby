class User < ApplicationRecord
  rolify
  has_secure_password
  has_many :sails, foreign_key: 'employee_id'
  # Validación para asegurarse de que solo los empleados pueden estar asociados a ventas.
  validates_inclusion_of :role, in: ['employee', 'admin', 'manager']
end
