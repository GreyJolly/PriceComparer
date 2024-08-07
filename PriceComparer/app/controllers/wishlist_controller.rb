class WishlistController < ApplicationController
  before_action :authorize_users
  before_action :set_wishlist, only: [:add_label, :remove_label]

  def wishlist
    @wishlisted_products_with_labels = Product
      .joins(:wishlists)
      .where(wishlists: { username: @user.username })
      .select("products.*, wishlists.labels AS wishlist_labels")

	if @wishlisted_products_with_labels == []
		flash[:custom] = "Nessun prodotto presente nella wishlist"
		return
	end
  end

  def add_to_wishlist
    # Ensure all required parameters are present
    required_params = [:name, :site, :price, :currency, :url]
    if required_params.any? { |param| params[param].blank? }
      flash[:alert] = "Please provide all required product information."
      redirect_to request.referer || root_path
      return
    end

    product_params = params.permit(:name, :description, :site, :price, :currency, :url, :category, :condition)

    # Find or create the product based on unique attributes (e.g., name and site)
    product = Product.find_or_create_by(name: product_params[:name], site: product_params[:site]) do |p|
      p.description = product_params[:description]
      p.price = product_params[:price]
      p.currency = product_params[:currency]
      p.url = product_params[:url]
	  p.category = product_params[:category]
	  p.condition = product_params[:condition]
    end

    if product.persisted?
		
	  # Create or find the wishlist entry
      wishlist_entry = Wishlist.find_or_create_by(username: current_user.username, id_product: product.id_product)
      if wishlist_entry.persisted?
        redirect_back fallback_location: root_path, notice: "Prodotto aggiunto alla wishlist con successo"
      else
        logger.error "Errors: #{wishlist_entry.errors.full_messages.join(", ")}"
        redirect_back fallback_location: root_path, alert: "Unable to add product to wishlist."
      end
    else
      # Handle product creation failure
      flash[:alert] = "Unable to create product."  # Set the flash alert message
      redirect_to request.referer || root_path
    end
  end

  def remove_from_wishlist
    @product = Product.find_by(id_product: params[:id_product])

    if @product
      wishlist_entry = Wishlist.find_by(id_product: @product.id_product, username: current_user.username)
	  
      if wishlist_entry&.persisted?
		wishlist_entry.destroy
        flash[:notice] = "Product removed from wishlist successfully."
		unless Wishlist.where(id_product: @product.id_product).where.not(username: current_user.username).exists?
			@product.destroy
		end
		else
        flash[:alert] = "Product not found in wishlist."
      end
    else
      flash[:alert] = "Product not found."
    end

    redirect_to request.referer || root_path
  end

  def search
    @query = params[:query]
    @min_price = params[:min_price]
    @max_price = params[:max_price]
    @label = params[:label]

    @wishlisted_products_with_labels = Product
      .joins(:wishlists)
      .where(wishlists: { username: current_user.username })
      .select("products.*, wishlists.labels AS wishlist_labels")

	if @wishlisted_products_with_labels == []
		flash[:custom] = "Nessun prodotto presente nella wishlist"
		render :wishlist
		return
	end
	
    @wishlisted_products_with_labels = @wishlisted_products_with_labels.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%") if @query.present?
    @wishlisted_products_with_labels = @wishlisted_products_with_labels.where("price >= ?", @min_price) if @min_price.present?
    @wishlisted_products_with_labels = @wishlisted_products_with_labels.where("price <= ?", @max_price) if @max_price.present?
    
	labelFlag = @label.present? && @wishlisted_products_with_labels != [] 	
	@wishlisted_products_with_labels = @wishlisted_products_with_labels.where("wishlists.labels LIKE ?", "%#{@label}%") if @label.present?
	if labelFlag && @wishlisted_products_with_labels == []
		flash[:custom] = "L'etichetta cercata non è presente nei risultati"
	else
		flash[:custom] = ""
	end

    @wishlisted_products_with_labels = @wishlisted_products_with_labels.order(price: :asc) if params[:order] == "asc"
    @wishlisted_products_with_labels = @wishlisted_products_with_labels.order(price: :desc) if params[:order] == "desc"

	if @wishlisted_products_with_labels == []
		flash[:custom] = "Non è stato trovato alcun risultato" if flash[:custom]==""
	else
		flash[:custom] = ""
	end

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
    @wishlist = Wishlist.find_by(id_product: params[:id], username: @user.username)
  end

  def authorize_users
    unless current_user
      flash[:alert] = "Non hai effettuato l'accesso. Sei stato redirezionato"
      redirect_to root_path
    end

    if current_user && current_user.isAdministrator && params[:user].present?
      @user = User.find_by(username: params[:user])
    else
      @user = current_user
    end
  end

end
