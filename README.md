# README

# Proyecto TTPS - Ruby

## Requerimientos

- Ruby 3.3.6
- Rails 8.0.0
- Database: SQLite3

## Instalación del proyecto

### Clonar el repo

```bash
$ git clone https://github.com/agosrubbini/TTPS-Ruby.git
```

### Instalar dependencias

```bash
$ bundle install
```

### Preparar la base de datos

```bash
$ rails db:reset
```

## Ejecución de la aplicación

```bash
$ rails server
```



# Ejecucion del seeds.rb:

```bash
$ rails db:seed
```

# Decisiones de diseño:

## Gemas:
- Rolify para manejar los tres roles (admin, manager, employee)
- CanCanCan para manejar las autorizaciones que tiene cada rol
- Devise para implementar el inicio y cierre de session
- ActiveStorage para el almacenamiento de las imagenes de los productos
- Ransack para implementar la busqueda de productos por nombre y el filtrado por categoria.

## Tablas:

- products: para modelar los productos. Los atributos color, size son de tipo string, y tiene una relacion con la tabla categories a traves del atributo category_id, el cual solo toma un valor, por lo tanto un producto puede tener una unica categoria

- sails: para modelar las ventas. Se relaciona con el usuario que creo la venta a traves de user_id. El campo client_dni hace referencia al DNI del cliente que se registra en la compra. El atributo is_deleted es booleano y sirve para cancelar la compra, lo que devuelve el stock al producto.

- products_sails: es la tabla intermedia que conecta la relacion muchos a muchos entre products y sails, se relaciona con ambas tablas a traves de product_id y sail_id. El campo amount_sold es la cantidad vendida del producto y total_amount el precio total del producto para la cantidad determinada.

- categories: representa las categorias a las que pueden pertenecer los productos. Su contenido esta cargado previamente en la base de datos. 

# Seeds
Se pre-cargaron datos para que sea facil el uso de la aplicacion.

Usuario administrador:

- Email: `admin@gmail.com`
- Contraseña: `123456`

Usuario Empleado:

- Emails: `emple@gmail.com`
- Contraseña: `123456`

agregar seeds corregir lo de joauqin