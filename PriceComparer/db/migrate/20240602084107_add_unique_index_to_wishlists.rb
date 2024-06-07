class AddUniqueIndexToWishlists < ActiveRecord::Migration[6.1]
  def change
    add_index :wishlists, [:product_id, :username], unique: true
  end
end
