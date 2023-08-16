FactoryBot.define do
  factory :product do
    title { "Sample Product" }
    description { "This is a sample product description" }
    price { 224 }
    url { "http://example.com" }    
  end
end