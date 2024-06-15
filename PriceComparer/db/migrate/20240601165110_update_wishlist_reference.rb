class UpdateWishlistReference < ActiveRecord::Migration[6.1]
	def change
		# Rename columns
		rename_column :wishlists, :ID_product, :product_id
		rename_column :wishlists, :users_name, :username
	
		# Ensure the referenced columns are properly indexed
		add_index :products, :id_product, unique: true
	
		# Add foreign key constraint for product_id
		add_foreign_key :wishlists, :products, column: :product_id, primary_key: :id_product
	
		# Add foreign key constraint for username
		add_foreign_key :wishlists, :users, column: :username, primary_key: :username
	  end
end
