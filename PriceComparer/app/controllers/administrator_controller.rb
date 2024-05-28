class AdministratorController < ApplicationController

def users
    @users = User.all
  end
end