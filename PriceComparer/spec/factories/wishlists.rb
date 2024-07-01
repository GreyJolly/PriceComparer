FactoryBot.define do
  factory :wishlist do
    product
    username { create(:user).username }
    labels { "test_label" }
  end
end
