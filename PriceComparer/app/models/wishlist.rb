class Wishlist < ApplicationRecord
<<<<<<< HEAD
=======
	belongs_to :product
	belongs_to :user, foreign_key: 'username', primary_key: 'username'
>>>>>>> 0ec63ad6fdf6d1bdd187b16eef7ca984a0512c73
end