class Product < ApplicationRecord
  has_many :wishlists
  has_many :wishlisted_by_users, through: :wishlists, source: :user
  before_create :generate_unique_product_id

  private

  def generate_unique_product_id
    loop do
      self.id_product = SecureRandom.uuid
      break unless Product.exists?(id_product: id_product)
    end
  end
end
