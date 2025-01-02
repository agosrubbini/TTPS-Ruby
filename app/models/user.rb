class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  rolify
  has_many :sails, foreign_key: "employee_id"

  validates :name, presence: true, uniqueness: { message: "nombre no disponible" }
  validates :email, presence: true, uniqueness: { message: "no disponible" }
  validate :password_presence

  def add_role_mio(role_name)
    if Role.exists?(name: role_name)
      self.roles = []
      add_role(role_name)
    end
  end

  def active?
    active == true
  end

  def soft_delete
    update_attribute(:active, false)
  end

  private

  def password_presence
    if password.present? && password_confirmation.blank?
      errors.add(:password_confirmation, "debe ser completado el campo confirmar contraseña si ingresa una nueva contraseña")
    elsif password_confirmation.present? && password.blank?
      errors.add(:password, "debe ser completado el campo contraseña si ingresa una confirmación")
    end
  end

  def update_password_to_random
    random_password = SecureRandom.urlsafe_base64(12) # Contraseña aleatoria de 12 caracteres
    self.password = random_password
    self.password_confirmation = random_password
    self.skip_password_validation = true
    self.save
  end
end
