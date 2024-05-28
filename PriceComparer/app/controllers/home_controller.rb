class HomeController < ApplicationController


  @products = Product.all

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

end
