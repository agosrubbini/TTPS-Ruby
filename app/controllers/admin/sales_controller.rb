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
    if @sale.cancel_sale
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

    if @sale.create_sale_and_update_stock(cart)
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

  def sale_params
    params.require(:sale).permit(:user_id, :client_dni, :completed_at)
  end
end
