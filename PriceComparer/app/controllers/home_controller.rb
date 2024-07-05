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

    @ebay_items ||= []  # Ensure @ebay_items is an array

    # Map eBay items to OpenStruct for uniformity
    ebay_products = @ebay_items.map do |item|
      OpenStruct.new(
        name: item["title"][0],
        description: item["title"][0],  # Assuming eBay items don't have a separate description field
        site: "eBay",
        price: item.dig("sellingStatus", 0, "currentPrice", 0, "__value__").to_f,  # Convert price to float for comparison
        currency: item.dig("sellingStatus", 0, "currentPrice", 0, "@currencyId"),
        url: item["viewItemURL"][0],
		category: item.dig('primaryCategory', 0, 'categoryName', 0)
		)
    end

    # Fetch DummyJSON items
    @dummyjson_items = if @query.present?
        DummyjsonService.search_items(@query)
      else
        []
      end

    @dummyjson_items ||= []  # Ensure @dummyjson_items is an array

    # Map DummyJSON items to OpenStruct for uniformity
    dummyjson_products = @dummyjson_items.map do |item|
      OpenStruct.new(
        name: item["title"],
        description: item["description"],
        site: "DummyJSON",
        price: item["price"].to_f,	# Convert price to float for comparison
        currency: "USD",			# Assuming DummyJSON prices are in USD
        url: "https://dummyjson.com/products/#{item["id"]}", # Construct a URL for the product
		category: item['category'],
      )
    end

    # Fetch and filter database products
    @products = Product.all
    @products = @products.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%") if @query.present?
    @products = @products.where("price >= ?", @min_price.to_f) if @min_price.present?
    @products = @products.where("price <= ?", @max_price.to_f) if @max_price.present?

    # Combine and sort products
    @combined_products = (@products + ebay_products + dummyjson_products)
    @combined_products = if @order == "asc"
        @combined_products.sort_by { |product| product.price }
      elsif @order == "desc"
        @combined_products.sort_by { |product| -product.price }
      else
        @combined_products
      end

    render :index
  end
end
