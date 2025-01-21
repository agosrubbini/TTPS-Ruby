class Admin::ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy activate ]
  load_and_authorize_resource
  # GET /products or /products.json
  def index
    @products = Product.all
    @products = Product.page(params[:page]).per(4)
  end

  # GET /products/1 or /products/1.json
  def show
  end

  def activate
    if @product.update(deleted_at: nil)  # Establece 'deleted_at' como nil para activar el producto
      redirect_to admin_products_path, notice: "Producto activado con éxito."
    else
      redirect_to admin_products_path, alert: "Error al activar el producto."
    end
  end

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
        process_images
        format.html { redirect_to admin_product_path(@product), notice: "Product was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      # Procesar imágenes para eliminación
      process_images if params[:product][:remove_images].present?

      # Actualizar el producto
      if @product.update(product_params.except(:images, :remove_images))
        # Adjuntar nuevas imágenes si hay
        @product.images.attach(product_params[:images]) if product_params[:images].present?

        format.html { redirect_to admin_product_path(@product), notice: "Producto actualizado con éxito." }
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

    def process_images
      if params[:product][:remove_images].present?
        params[:product][:remove_images].each do |signed_id|
          # Encuentra la imagen a través de signed_id
          attachment = @product.images.find_by(id: signed_id)

          if attachment
            attachment.purge
          end
        end
      end

      # Limitar a 3 imágenes, eliminando las extra
      if @product.images.count > 3
        excess_images = @product.images[3..-1] # Obtener imágenes extra
        excess_images.each(&:purge)
      end
    end
end
