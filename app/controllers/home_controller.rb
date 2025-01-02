class HomeController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true)
                  .where("stock > ?", 0)  # Filtra los productos con stock mayor a cero
                  .includes(:category)
                  .page(params[:page])
                  .per(4)
  end
  def show
    @product = Product.find(params[:id])
  end
end
