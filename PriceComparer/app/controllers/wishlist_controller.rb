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
    product_params = params.permit(:name, :description, :site, :price, :currency, :url)

    # Find or create the product based on unique attributes (e.g., name and site)
    product = Product.find_or_create_by(name: product_params[:name], site: product_params[:site]) do |p|
      p.description = product_params[:description]
      p.price = product_params[:price]
      p.currency = product_params[:currency]
      p.url = product_params[:url]
    end

    if product.persisted?
      # Create or find the wishlist entry
      wishlist_entry = Wishlist.find_or_create_by(username: current_user.username, product_id: product.id_product)
      if wishlist_entry.persisted?
        redirect_to request.referer, notice: "Product added to wishlist successfully."
      else
        logger.error "Errors: #{wishlist_entry.errors.full_messages.join(", ")}"
        redirect_to request.referer, alert: "Unable to add product to wishlist."
      end
    else
      # Handle product creation failure
      redirect_to request.referer, alert: "Unable to create product."
    end
  end

  def remove_from_wishlist
    @product = Product.find(params[:id])

    product_to_be_destroyed = Wishlist.find_by(product_id: @product.id, username: current_user.username)

    product_to_be_destroyed.destroy if product_to_be_destroyed.persisted?
  end

  def search
    authorize_users()

    @query = params[:query]
    @min_price = params[:min_price]
    @max_price = params[:max_price]
    @label = params[:label]

    @wishlistedProducts = Product.joins(:wishlists).where(wishlists: { username: current_user.username })
    @wishlistedProducts = @wishlistedProducts.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%") if @query.present?
    @wishlistedProducts = @wishlistedProducts.where("price >= ?", @min_price) if @min_price.present?
    @wishlistedProducts = @wishlistedProducts.where("price <= ?", @max_price) if @max_price.present?
    @wishlistedProducts = @wishlistedProducts.joins(:wishlists).where("wishlists.labels LIKE ?", "%#{@label}%") if @label.present?

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
