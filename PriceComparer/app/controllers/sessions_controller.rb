class SessionsController < Devise::SessionsController
	before_action :configure_sign_in_params, only: [:create]
	
	def new
	  self.resource = resource_class.new(sign_in_params)
	  store_location_for(resource, params[:redirect_to])
	  super
	end
  
	protected
  
	def configure_sign_in_params
	  devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
	end
  end
  