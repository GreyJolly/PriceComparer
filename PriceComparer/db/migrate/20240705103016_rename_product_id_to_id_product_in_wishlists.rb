class RenameProductIdToIdProductInWishlists < ActiveRecord::Migration[6.1]
  def change
    rename_column :wishlists, :product_id, :id_product
  end
end
