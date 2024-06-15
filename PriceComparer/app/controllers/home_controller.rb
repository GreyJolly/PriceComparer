class HomeController < ApplicationController



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
    @order = params[:order]
  
    # Fetch eBay items
    @ebay_items = if @query.present?
                    EbayService.search_items(@query)
                  else
                    []
                  end
  
    Rails.logger.info "Ebay items: #{@ebay_items}"
  
    @ebay_items ||= []  # Ensure @ebay_items is an array
  
    # Map eBay items to OpenStruct for uniformity
    ebay_products = @ebay_items.map do |item|
      OpenStruct.new(
        name: item['title'][0],
        description: item['title'][0],  # Assuming eBay items don't have a separate description field
        site: 'eBay',
        price: item.dig('sellingStatus', 0, 'currentPrice', 0, '__value__').to_f,  # Convert price to float for comparison
        currency: item.dig('sellingStatus', 0, 'currentPrice', 0, '@currencyId'),
        url: item['viewItemURL'][0]
      )
    end
  
    Rails.logger.info "Mapped eBay products: #{ebay_products}"
  
    # Fetch and filter database products
    @products = Product.all
    @products = @products.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%") if @query.present?
    @products = @products.where("price >= ?", @min_price.to_f) if @min_price.present?
    @products = @products.where("price <= ?", @max_price.to_f) if @max_price.present?
  
    Rails.logger.info "Filtered database products: #{@products}"
  
    # Combine and sort products
    @combined_products = (@products + ebay_products)
    @combined_products = if @order == 'asc'
                           @combined_products.sort_by { |product| product.price }
                         elsif @order == 'desc'
                           @combined_products.sort_by { |product| -product.price }
                         else
                           @combined_products
                         end
  
    Rails.logger.info "Combined products: #{@combined_products}"
  
    render :index
  end
end
