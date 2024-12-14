class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  rolify
  has_many :sails, foreign_key: "employee_id"

  # Validación para roles
  # validates_inclusion_of :role, in: ['employee', 'admin', 'manager']

  # validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, unless: -> { skip_password_validation }

  attr_accessor :password, :password_confirmation, :skip_password_validation

  before_save :hash_password

  def add_role_mio(role_name)
    if Role.exists?(name: role_name)
      self.roles = []
      add_role(role_name)
    end
  end

  def active?
    active == true
  end


  # def recover
  #   update(encrypted_password: BCrypt::Password.create('123456'))
  # end
  #
  def soft_delete
    update_attribute(:active, false)
  end

  private

  def password_required
    if encrypted_password.blank? && password.blank?
      errors.add(:password, "can't be blank")
    end
  end

  def hash_password
    # Solo encripta la contraseña si la nueva contraseña está presente
    if password.present?
      self.encrypted_password = BCrypt::Password.create(password)
    end
  end

  def update_password_to_random
    random_password = SecureRandom.urlsafe_base64(12) # Contraseña aleatoria de 12 caracteres
    self.password = random_password
    self.password_confirmation = random_password
    self.skip_password_validation = true
    self.save # Guardamos el usuario con la nueva contraseña
  end
end
