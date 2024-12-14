class Admin::SailsController < ApplicationController
  before_action :load_products, only: [:new, :add_product, :index ]
  
  def new
    @sail = Sail.new
    @selected_products = load_cart
  end

  def show
    @sail = Sail.find(params[:id])  
  end

  def index
    @sails = Sail.all
  end

  def destroy
    @sail = Sail.find(params[:id])
    @sail.products_sails.each do |product_sail|
      product = Product.find(product_sail.product_id)
      product.update(stock: product.stock + product_sail.amount_sold)
    end
    if @sail.update(is_deleted: true)  # Marca la venta como cancelada
      flash[:notice] = "Venta cancelada exitosamente."
    else
      flash[:alert] = "No se pudo cancelar la venta."
    end
    redirect_to admin_sails_path
  end

  def add_product
    cart = load_cart
    product_id = params[:product_id].to_i
    amount = params[:amount].to_i

    product = Product.find(product_id)
    if amount > product.stock
      flash[:alert] = "No puedes agregar más del stock disponible."
    else
      cart[product_id] = amount
      save_cart(cart)
      flash[:notice] = "Producto agregado al carrito."
    end

    redirect_to new_admin_sail_path
  end

  def create
    cart = load_cart
    @sail = Sail.new(sail_params)
    @sail.total_amount = calculate_total(cart)

    if @sail.save
      cart.each do |product_id, amount|
        product = Product.find(product_id)
        total_price = product.price * amount

        # Crear la relación en ProductSail
        ProductsSail.create!(
          sail: @sail,
          product: product,
          amount_sold: amount,
          total_amount: total_price
        )

        # Actualizar el stock del producto
        product.update!(stock: product.stock - amount)
      end

      clear_cart
      redirect_to admin_sail_path(@sail), notice: "Venta creada exitosamente."
    else
      flash[:alert] = @sail.errors.full_messages.join(", ")
      redirect_to new_admin_sail_path
    end
  end

  private

  def load_products
    @products = Product.where("stock > 0")
  end

  def load_cart
    session[:cart] ||= {}
  end

  def save_cart(cart)
    session[:cart] = cart
  end

  def clear_cart
    session[:cart] = {}
  end

  def calculate_total(cart)
    cart.sum do |product_id, amount|
      product = Product.find(product_id)
      product.price * amount
    end
  end

  def sail_params
    params.require(:sail).permit(:user_id, :client_dni, :completed_at)
  end
end
