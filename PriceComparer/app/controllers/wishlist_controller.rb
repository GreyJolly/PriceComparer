class WishlistController < ApplicationController
  before_action :authorize_users

  def authorize_users
    unless current_user
      flash[:alert] = "You are not currently logged in. You have been redirected"
      redirect_to root_path
    end
  end

  def wishlist
    @user = User.find_by(username: params[:user]) if current_user.isAdministrator
	@user = current_user if !@user.present?
	
	@wishlistedProducts = Product.joins(:wishlists).where(wishlists: { username: @user.username })
  end

  def add_to_wishlist

    @product = Product.find(params[:id])
	
	# TODO: Check if product is already present
	Wishlist.create!( { product_id: @product.id, username: @user.username })
  end

  def remove_from_wishlist

    @product = Product.find(params[:id])
	@user = current_user
	
	# TODO: Check if the product is present
	Wishlist.find_by(product_id: @product.id, username: @user.username).destroy
  end


  def search
    @query = params[:query]
    @min_price = params[:min_price]
    @max_price = params[:max_price]
    @wishlistedProducts = Product.joins(:wishlists).where(wishlists: { username: current_user.username })
    @wishlistedProducts = @wishlistedProducts.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%") if @query.present?
    @wishlistedProducts = @wishlistedProducts.where("price >= ?", @min_price) if @min_price.present?
    @wishlistedProducts = @wishlistedProducts.where("price <= ?", @max_price) if @max_price.present?
    @wishlistedProducts = @wishlistedProducts.order(price: :asc) if params[:order] == "asc"
    @wishlistedProducts = @wishlistedProducts.order(price: :desc) if params[:order] == "desc"
    render :wishlist
  end
end
