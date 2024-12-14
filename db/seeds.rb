Role.find_or_create_by(name: 'admin')
Role.find_or_create_by(name: 'manager')
Role.find_or_create_by(name: 'employee')

# Encriptar la contraseña manualmente usando BCrypt
password = BCrypt::Password.create('123456')

# Crear el usuario con la contraseña encriptada
user = User.find_or_create_by(email: 'admin@gmail.com') do |u|
  u.name = 'admin'
  u.phone = '2213456789'
  u.encrypted_password = password  # Guardar la contraseña encriptada
  u.active = true
end
# Asignar rol de admin al usuario
user.add_role(:admin)

Category.find_or_create_by(name: 'Remeras')
Category.find_or_create_by(name: 'Buzos')
Category.find_or_create_by(name: 'Pantalones')

Product.find_or_create_by(name: 'Básica') do |p|
  p.description = 'Remera de algodón de alta calidad'
  p.price = 20000
  p.stock = 100
  p.color = 'Blanco'
  p.size = 'M'
  p.entry_date = Date.today
  p.category_id = Category.find_by(name: 'Remeras').id  # Referencia a la categoría 'Remeras'
end

Product.find_or_create_by(name: 'Over') do |p|
  p.description = 'Buzo oversize con capucha y bolsillo frontal'
  p.price = 50000
  p.stock = 50
  p.color = 'Azul'
  p.size = 'L'
  p.entry_date = Date.today
  p.category_id = Category.find_by(name: 'Buzos').id  # Referencia a la categoría 'Buzos'
end


