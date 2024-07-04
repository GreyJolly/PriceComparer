class Product < ApplicationRecord
  has_many :wishlists, foreign_key: "id_product", primary_key: "id_product"
  has_many :reports, primary_key: "id_product", foreign_key: "id_product"
  before_create :generate_unique_product_id

  private

  def generate_unique_product_id
    loop do
      self.id_product = SecureRandom.uuid
      break unless Product.exists?(id_product: id_product)
    end
  end
end
