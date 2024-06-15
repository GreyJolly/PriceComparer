class AnalystController < ApplicationController
	before_action :authorize_analysts

	def authorize_analysts
		unless current_user && current_user.isAnalyst
		  flash[:alert] = "You are not authorized to access this page. You have been redirected"
		  redirect_to root_path
		end
	end

	def products_dashboard
	end

end
