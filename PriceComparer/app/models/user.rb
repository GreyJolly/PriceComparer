class User < ApplicationRecord
  def role
    if isAdministrator?
      :admin
    elsif isAnalyst?
      :analyst
    else
      :user
    end
  end

  def admin?
    isAdministrator
  end

  def analyst?
    isAnalyst
  end
end
