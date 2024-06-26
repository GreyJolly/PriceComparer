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

    @wishlisted_by_price_range = @price_ranges.map do |range|
      count = Wishlist.joins(:product)
        .where("products.price >= ? AND products.price < ?", range[:min], range[:max])
        .count
      { min: range[:min], max: range[:max], count: count }
    end
  end
end
