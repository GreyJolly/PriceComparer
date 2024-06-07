class AddLabelsToWishlists < ActiveRecord::Migration[6.1]
	def change
	  add_column :wishlists, :labels, :string
	end
end