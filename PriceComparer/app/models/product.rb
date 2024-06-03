class Product < ApplicationRecord
	has_many :wishlists
	has_many :wishlisted_by_users, through: :wishlists, source: :user
end