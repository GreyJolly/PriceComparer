FactoryBot.define do
  factory :report do
    title { "Sample Report" }
    content { "This is a sample report content." }
    created_at { Time.now }
    updated_at { Time.now }

    association :product, factory: :product, strategy: :build

    after(:build) do |report|
      report.id_product = report.product.id_product
    end
  end
end
