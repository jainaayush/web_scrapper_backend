require 'rails_helper'

RSpec.describe 'Api::V1::ProductsController', type: :request do
  describe "GET #index" do
    it "returns a JSON response with products" do
      product = create(:product)  # Assuming you have a factory for Product model

      get '/api/v1/product'      

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)      
      expect(json.count).to eq 1
    end
  end

  describe "POST #scrape" do
    let(:valid_url) { "https://example.com/product" }
    let(:invalid_url) { "invalid-url" }

    context "when URL is present and product exists" do
      it "returns the product JSON" do
        product = create(:product, url: valid_url)

        post '/api/v1/scrape', params: { url: valid_url }

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)        
        expect(json['title']).to eq(product.title)
      end
    end

    context "when URL is present and product doesn't exist" do
      it "creates and returns a new product" do
        allow_any_instance_of(WebScraperService).to receive(:scrape_data).and_return(
          data: { title: "Sample Product" },
          image_url: "https://images.pexels.com/photos/60597/dahlia-red-blossom-bloom-60597.jpeg"
        )

        post '/api/v1/scrape', params: { url: valid_url }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["title"]).to eq("Sample Product")
        expect(Product.count).to eq(1)
      end
    end

    context "when URL is missing" do
      it "returns an error JSON" do
        post '/api/v1/scrape'

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "URL parameter is missing" })
      end
    end    
  end
end
