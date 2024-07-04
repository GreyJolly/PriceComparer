class AnalystController < ApplicationController
  before_action :authorize_analysts

  def authorize_analysts
    unless current_user && current_user.isAnalyst
      flash[:alert] = "You are not authorized to access this page. You have been redirected"
      redirect_to root_path
    end
  end

  def products_dashboard
    # Fetch the number of wishlisted items by category
    @wishlisted_by_category = Wishlist.joins(:product)
      .group("products.category")
      .count

    # Fetch the custom price ranges from the params
    if params[:price_ranges]
      permitted_params = params.permit(price_ranges: [:min, :max])
      @price_ranges = permitted_params[:price_ranges].values.map do |range|
        { min: range[:min].to_f, max: range[:max].to_f }
      end
    else
      @price_ranges = []
    end
    @wishlisted_by_price_range = load_price_ranges_with_counts(params[:price_ranges]) 
	print(@wishlisted_by_price_range)
  end

  private 

  def load_price_ranges_with_counts(price_ranges)
    return [] unless price_ranges
	
	params.permit(price_ranges: [:min, :max]).require(:price_ranges).to_h.map do |index, range|
      min = range[:min].to_f
      max = range[:max].to_f
      count = Product.where(price: min..max).count
      { min: min, max: max, count: count }
    end
  end
end
