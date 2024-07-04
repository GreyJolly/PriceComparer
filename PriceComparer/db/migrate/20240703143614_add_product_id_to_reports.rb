class AddProductIdToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :id_product, :integer
    add_index :reports, :id_product
  end
end
