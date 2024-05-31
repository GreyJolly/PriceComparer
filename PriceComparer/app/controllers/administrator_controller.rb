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
		@administrator = params[:administrator] == '1'
		@analyst = params[:analyst] == '1'
		@alphabetical = params[:alphabetical] == '1'
	
		@users = User.all
	
		if @administrator && @analyst
		  @users = @users.where(isAdministrator: true).or(@users.where(isAnalyst: true))
		elsif @administrator
		  @users = @users.where(isAdministrator: true)
		elsif @analyst
		  @users = @users.where(isAnalyst: true)
		end
	
		if @query.present?
		  @users = @users.where("name LIKE ? OR email LIKE ?", "%#{@query}%", "%#{@query}%")
		end
	
		@users = @users.order(:name) if @alphabetical
	
		render :users_list
	end

end
