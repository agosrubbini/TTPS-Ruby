class HomeController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    # @products = Product.all
    @products = @q.result(distinct: true).includes(:category)
  end
  def show
    @product = Product.find(params[:id])
  end
end
