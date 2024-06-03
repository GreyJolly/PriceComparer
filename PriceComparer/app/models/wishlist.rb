class Wishlist < ApplicationRecord
	belongs_to :product
	belongs_to :user, foreign_key: 'username', primary_key: 'username'
end