class WishlistController < ApplicationController
  before_action :authorize_users, :set_wishlist, only: [:add_label, :remove_label]

  def authorize_users
    unless current_user
      flash[:alert] = "You are not currently logged in. You have been redirected"
      redirect_to root_path
    end
  end

  def wishlist
    @user = User.find_by(username: params[:user]) if current_user.isAdministrator
    @user = current_user if !@user.present?

    @wishlistedProducts = Product.joins(:wishlists).where(wishlists: { username: @user.username }).includes(:wishlists)
  end

  def add_to_wishlist
    @product = Product.find(params[:id])

    # TODO: Check if product is already present
    Wishlist.create!({ product_id: @product.id, username: @user.username })
  end

  def remove_from_wishlist
    @product = Product.find(params[:id])

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

  def add_label

	if params[:label_name] =~ /\A[a-zA-Z0-9 ]*\z/
		@wishlist.add_label(params[:label_name])
	else
		flash[:error] = "Sono consentiti solo caratteri alfanumerici e lo spazio nel nome di un etichetta."
	end
    redirect_back(fallback_location: root_path)
  end

  def remove_label
    @wishlist.remove_label(params[:label_name])
    redirect_back(fallback_location: root_path)
  end

  private

  def set_wishlist
    @wishlist = Wishlist.find(params[:id])
  end
end
