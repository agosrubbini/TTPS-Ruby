class Admin::ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy activate ]
  load_and_authorize_resource
  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  def activate
    if @product.update(deleted_at: nil)  # Establece 'deleted_at' como nil para activar el producto
      redirect_to admin_products_path, notice: 'Producto activado con éxito.'
    else
      redirect_to admin_products_path, alert: 'Error al activar el producto.'
    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to admin_product_path(@product), notice: "Product was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to admin_product_path(@product), notice: "Product was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy  # Esto ahora actualizará deleted_at en lugar de eliminar el registro.
  
    respond_to do |format|
      format.html { redirect_to admin_products_path, notice: "Product was successfully marked as deleted." }
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :stock, :color, :size, :category_id, :entry_date, :deleted_at, images: [])
    end
end
