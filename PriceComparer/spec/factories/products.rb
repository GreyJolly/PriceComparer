# spec/factories/products.rb
FactoryBot.define do
  factory :product do
    sequence(:id_product) { |n| n }
    name { "Test Product" }
    description { "Test Description" }
    site { "Test Site" }
    price { 10.0 }
    category { "Test Category" }
    url { "http://example.com/product" }
    currency { "EUR" }
  end
end
