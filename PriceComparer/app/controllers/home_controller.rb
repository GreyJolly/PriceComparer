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
    @products = if @query.present?
                  Product.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
                else
                  Product.all
                end
    render :index
  end
  
end
