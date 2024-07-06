class HomeController < ApplicationController
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
        site: "eBay",
        price: item.dig("sellingStatus", 0, "currentPrice", 0, "__value__").to_f,  # Convert price to float for comparison
        currency: item.dig("sellingStatus", 0, "currentPrice", 0, "@currencyId"),
        url: item["viewItemURL"][0],
        category: item.dig("primaryCategory", 0, "categoryName", 0),
        condition: item.dig("condition", 0, "conditionDisplayName", 0),
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
        category: item["category"],
      )
    end

    # Combine and sort products

    @combined_products = []

    max_length = [ebay_products.length, dummyjson_products.length].max

    (0...max_length).each do |i|
      @combined_products << dummyjson_products[i] if i < dummyjson_products.length
      @combined_products << ebay_products[i] if i < ebay_products.length
    end

    if params[:condition] == "new"
      @combined_products = @combined_products.select do |product|
        product.condition.present? && product.condition.include?("Nuovo") && !product.condition.include?("Come Nuovo")
      end
    elsif params[:condition] == "used"
      @combined_products = @combined_products.select do |product|
        product.condition.present? && (!product.condition.include?("Nuovo") || product.condition.include?("Come Nuovo"))
      end
    end

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
