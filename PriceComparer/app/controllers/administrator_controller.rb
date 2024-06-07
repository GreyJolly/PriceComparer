class AdministratorController < ApplicationController
	before_action :authorize_admins

	def authorize_admins
		unless current_user && current_user.isAdministrator
		  flash[:alert] = "You are not authorized to access this page. You have been redirected"
		  redirect_to root_path
		end
	end

	def users_list
    	@users = User.all
		@analyst_count = User.where(isAnalyst: true).count
		@administrator_count = User.where(isAdministrator: true).count
		@analystAdministrato_count = User.where(isAnalyst: true, isAdministrator: true).count
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
		@neither_role = params[:neither_role] == '1'
		@alphabetical = params[:alphabetical] == '1'
	
		@users = User.all

		# Check for conflicting selections
		if @administrator && !@analyst && @neither_role
			if flash[:error] != "You cannot select 'Administrator' and 'Neither Role' at the same time."	
				flash[:error] = "You cannot select 'Administrator' and 'Neither Role' at the same time."
				redirect_to search_users_users_path and return
			end
		elsif !@administrator && @analyst && @neither_role
			if flash[:error] != "You cannot select 'Analyst' and 'Neither Role' at the same time."
				flash[:error] = "You cannot select 'Analyst' and 'Neither Role' at the same time."
				redirect_to search_users_users_path and return
			end
		elsif @administrator && @analyst && @neither_role
			if flash[:error] != "You cannot select 'Administrator', 'Analyst', and 'Neither Role' at the same time."
				flash[:error] = "You cannot select 'Administrator', 'Analyst', and 'Neither Role' at the same time."
				redirect_to search_users_users_path and return
			end
		end
	
		if @administrator && @analyst && !@neither_role
			@users = @users.where(isAdministrator: true, isAnalyst: true)
		elsif @administrator && !@analyst && !@neither_role
		  @users = @users.where(isAdministrator: true)
		elsif !@administrator && @analyst && !@neither_role
		  @users = @users.where(isAnalyst: true)
		elsif !@administrator && !@analyst && @neither_role
			@users = @users.where(isAdministrator: false, isAnalyst: false)
		end
	
		if @query.present?
		  @users = @users.where("username LIKE ? OR email LIKE ?", "%#{@query}%", "%#{@query}%")
		end
	
		@users = @users.order(:username) if @alphabetical

		@analyst_count = @users.where(isAnalyst: true).count
		@administrator_count = @users.where(isAdministrator: true).count
		@analystAdministrato_count = @users.where(isAnalyst: true, isAdministrator: true).count
		
		render :users_list
	end

end
