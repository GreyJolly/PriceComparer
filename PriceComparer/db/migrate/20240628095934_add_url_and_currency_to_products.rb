class AddUrlAndCurrencyToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :url, :string
    add_column :products, :currency, :string
  end
end
