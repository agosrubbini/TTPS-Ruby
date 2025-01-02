class Admin::SalesController < ApplicationController
  before_action :load_products, only: [ :new, :add_product, :index ]

  def new
    @sale = Sale.new
    @selected_products = load_cart
  end

  def show
    @sale = Sale.find(params[:id])
  end

  def index
    @sales = Sale.all
    @sales = Sale.page(params[:page]).per(4)
  end

  def destroy
    @sale = Sale.find(params[:id])
    @sale.product_sales.each do |product_sale|
      product = Product.find(product_sale.product_id)
      product.update(stock: product.stock + product_sale.amount_sold)
    end
    if @sale.update(is_deleted: true)  # Marca la venta como cancelada
      flash[:notice] = "Venta cancelada exitosamente."
    else
      flash[:alert] = "No se pudo cancelar la venta."
    end
    redirect_to admin_sales_path
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

    redirect_to new_admin_sale_path
  end

  def create
    cart = load_cart
    @sale = Sale.new(sale_params)
    @sale.total_amount = calculate_total(cart)

    if @sale.save
      cart.each do |product_id, amount|
        product = Product.find(product_id)
        total_price = product.price * amount

        # Crear la relación en ProductSail
        ProductsSale.create!(
          sale: @sale,
          product: product,
          amount_sold: amount,
          total_amount: total_price
        )

        # Actualizar el stock del producto
        product.update!(stock: product.stock - amount)
      end

      clear_cart
      redirect_to admin_sale_path(@sale), notice: "Venta creada exitosamente."
    else
      flash[:alert] = @sale.errors.full_messages.join(", ")
      redirect_to new_admin_sale_path
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

  def sale_params
    params.require(:sale).permit(:user_id, :client_dni, :completed_at)
  end
end
