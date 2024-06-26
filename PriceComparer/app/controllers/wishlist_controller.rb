class WishlistController < ApplicationController
  before_action :authorize_users, :set_wishlist, only: [:add_label, :remove_label]

  def authorize_users
    unless current_user
      flash[:alert] = "Non hai effettuato l'accesso. Sei stato redirezionato"
      redirect_to root_path
    end

	if current_user.isAdministrator && params[:user].present?
		@user = User.find_by(username: params[:user])
	  else
		@user = current_user
	  end
  end

  def wishlist
	authorize_users()
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
	authorize_users()
	
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
