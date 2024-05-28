class Wishlist < ActiveRecord::Migration[6.1]
  def change
    create_table :wishlist do |t|
      t.integer :ID_product
      t.string :users_name
    end
  end
end
