puts("inicio")
Role.find_or_create_by(name: 'admin')
puts("role admin")

Role.find_or_create_by(name: 'manager')
puts("rol manager")

Role.find_or_create_by(name: 'employee')
puts("rol employee")

Category.find_or_create_by(name: 'Remeras')
puts("categoria remeras")

Category.find_or_create_by(name: 'Buzos')
puts("categoria buzos")

Category.find_or_create_by(name: 'Pantalones')
puts("categoria pantalones")

def create_user_with_role(email, name, phone, password, active, role)
  user = User.find_or_initialize_by(email: email) do |u|
    u.name = name
    u.phone = phone
    u.password = password
    u.password_confirmation = password
    u.active = active
  end
  user.save!
  user.add_role(role) unless user.has_role?(role)
  puts("Rol #{role} asignado correctamente al usuario #{user.name}")
end

create_user_with_role('admin@gmail.com', 'admin', '2213456789', '123456', true, :admin)
create_user_with_role('emple@gmail.com', 'emple', '2213456789', '123456', true, :employee)


images_path = Rails.root.join('app', 'assets', 'images')

def attach_image(product, images_path)
  folder_name = "#{product.name}_#{product.color}"
  folder_path = images_path.join(folder_name)

  # Verificar si la carpeta existe y contiene imágenes
  if Dir.exist?(folder_path)
    image_file = Dir.children(folder_path).first # Asume una imagen por carpeta
    if image_file
      file_path = folder_path.join(image_file)
      product.images.attach(
        io: File.open(file_path),
        filename: image_file,
        content_type: `file --brief --mime-type #{file_path}`.strip
      )
    end
  else
    puts "No se encontró la carpeta para #{folder_name}"
  end
end

products = [
  { name: 'Basica', color: 'Blanco', description: 'Remera de algodón de alta calidad', price: 20000, stock: 100, size: 'M', category: 'Remeras' },
  { name: 'Over', color: 'Marron', description: 'Buzo oversize con capucha y bolsillo frontal', price: 50000, stock: 50, size: 'L', category: 'Buzos' },
  { name: 'Basica', color: 'Marron', description: 'Remera de algodón de alta calidad', price: 20000, stock: 100, size: 'L', category: 'Remeras' },
  { name: 'Over', color: 'Negro', description: 'Buzo oversize con capucha y bolsillo frontal', price: 50000, stock: 50, size: 'S', category: 'Buzos' }
]

products.each do |attrs|
  product = Product.find_or_create_by(name: attrs[:name], color: attrs[:color]) do |p|
    p.description = attrs[:description]
    p.price = attrs[:price]
    p.stock = attrs[:stock]
    p.size = attrs[:size]
    p.entry_date = Date.today
    p.category_id = Category.find_by(name: attrs[:category]).id
  end
  attach_image(product, images_path)
end

puts("productos creados")

require 'securerandom'

5.times do |i|
  # Crear una venta con los atributos iniciales
  sale = Sale.create!(
    completed_at: DateTime.current,
    total_amount: 1, # Se calculará luego
    user_id: 2,
    client_dni: '22222222'
  )

  # Seleccionar entre 2 y 4 productos al azar
  selected_products = Product.order('RANDOM()').limit(rand(2..4))
  product_sales_data = []

  selected_products.each do |product|
    # Generar una cantidad aleatoria de productos vendidos, pero asegurarse de que no supere el stock
    max_amount = [ product.stock, 30 ].min
    next if max_amount < 5 # Ignorar productos con stock insuficiente para la venta mínima

    amount_sold = rand(5..max_amount)

    # Verificar si el producto ya está asociado a esta venta
    existing_entry = product_sales_data.find { |entry| entry[:product_id] == product.id }

    if existing_entry
      # Sumar la cantidad vendida al registro existente
      new_amount = existing_entry[:amount_sold] + amount_sold
      if new_amount <= product.stock
        existing_entry[:amount_sold] = new_amount
        existing_entry[:total_amount] = new_amount * product.price
      end
    else
      # Crear un nuevo registro en la tabla intermedia
      product_sales_data << {
        product_id: product.id,
        sale_id: sale.id,
        amount_sold: amount_sold,
        total_amount: amount_sold * product.price
      }
    end
  end
  puts("holaaaaaaaaaaaaaa")

  # Crear los registros en ProductSales
  ProductSale.insert_all(product_sales_data)
  puts("holaaaaaaaaaaaaaa")

  # Calcular el total_amount de la venta y actualizarla
  sale_total_amount = product_sales_data.sum { |entry| entry[:total_amount] }
  sale.update!(total_amount: sale_total_amount)
  puts("holaaaaaaaaaaaaaa")

  # Reducir el stock de los productos vendidos
  product_sales_data.each do |entry|
    product = Product.find(entry[:product_id])
    product.update!(stock: product.stock - entry[:amount_sold])
  end
  puts("holaaaaaaaaaaaaaa")

  puts "Venta #{i + 1} creada con ID #{sale.id} y total de $#{sale.total_amount}"
end
