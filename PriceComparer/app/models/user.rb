class User < ApplicationRecord
  has_many :wishlists, foreign_key: 'username', primary_key: 'username'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def self.from_omniauth(auth)
	user = where(email: auth.info.email).first_or_initialize do |u|
	  u.username = auth.info.nickname || auth.info.name.split(" ").join("_")
	  u.password = Devise.friendly_token[0, 20]
	end
  
	user.provider = auth.provider
	user.uid = auth.uid
	user.oauth_token = auth.credentials.token
	user.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
	user.oauth_refresh_token = auth.credentials.refresh_token if auth.credentials.refresh_token
	user.save!
	user
  end

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
