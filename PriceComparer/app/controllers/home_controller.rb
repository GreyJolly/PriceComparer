class HomeController < ApplicationController

  def wishlist
    @product = Product.find(params[:id])
    # Logic to wishlist
    print("Wishlisted " + @product.name + "\n")
  end

  def report
    @product = Product.find(params[:id])
    # Logic to report
    print("Reported " + @product.name + "\n")
  end

  def index
    @products = Product.all
  end

  def search
    @query = params[:query]
    @min_price = params[:min_price]
    @max_price = params[:max_price]
    @products = if @query.present?
                  Product.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
                else
                  Product.all
                end
    @products = @products.where("price >= ?", @min_price) if @min_price.present?
    @products = @products.where("price <= ?", @max_price) if @max_price.present?
    @products = @products.order(price: :asc) if params[:order] == 'asc'
    @products = @products.order(price: :desc) if params[:order] == 'desc'
    render :index
  end

end
