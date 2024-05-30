class AdministratorController < ApplicationController
	before_action :authorize_admins

	def authorize_admins
		unless current_user && current_user.isAdministrator
		  flash[:alert] = "You are not authorized to access the users list. You have been redirected"
		  redirect_to root_path # Or any other path
		end
	end

	def users_list
    	@users = User.all
	end

	def toggle_analyst
    	@user = User.find(params[:id])
    	@user.update(isAnalyst: !@user.isAnalyst)
    	redirect_back(fallback_location: root_path)
	end

	def toggle_admin
    	@user = User.find(params[:id])
    	@user.update(isAdministrator: !@user.isAdministrator)
    	redirect_back(fallback_location: root_path)
	end

	def search_users
		@query = params[:query_user]
		@users = if @query.present?
						User.where("name LIKE ? OR email LIKE ?", "%#{@query}%", "%#{@query}%")
					else
						User.all
					end
		render :users_list
	end

end
