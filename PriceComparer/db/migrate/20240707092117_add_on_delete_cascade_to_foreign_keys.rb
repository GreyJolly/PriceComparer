class AddOnDeleteCascadeToForeignKeys < ActiveRecord::Migration[6.1]
	def change
	  # Remove existing foreign keys
	  remove_foreign_key :wishlists, :products
	  remove_foreign_key :wishlists, :users
  
	  # Add new foreign keys with ON DELETE CASCADE
	  add_foreign_key :wishlists, :products, column: :id_product, primary_key: :id_product, on_delete: :cascade
	  add_foreign_key :wishlists, :users, column: :username, primary_key: :username, on_delete: :cascade
	  add_foreign_key :reports, :products, column: :id_product, primary_key: :id_product, on_delete: :cascade
	end
  end