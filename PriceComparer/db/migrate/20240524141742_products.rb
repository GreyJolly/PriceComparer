class Products < ActiveRecord::Migration[6.1]
  def change
      create_table :products do |t|
        t.integer :id_product
        t.string :name
        t.text :description
        t.string :site
        t.decimal :price, precision: 10, scale: 2
        t.string :category
      end
  end
end
