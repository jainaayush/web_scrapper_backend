require 'rails_helper'
Sidekiq::Testing.fake!

RSpec.describe 'ProductUpdateJob', type: :job do
  let(:sample_url) { "https://example.com/sample-url" }
  let(:sample_image_url) { "https://images.pexels.com/photos/60597/dahlia-red-blossom-bloom-60597.jpeg" }

  before do
    # Stub WebScraperService to return sample data
    allow_any_instance_of(WebScraperService).to receive(:scrape_data).and_return(
      data: { title: "update title from sample title" },
      image_url: sample_image_url
    )
  end

  describe "#perform" do
    it "updates products with scraped data and attaches images" do
      product1 = create(:product, url: sample_url)
      product2 = create(:product, url: sample_url)
      product_without_url = create(:product, url: nil)

      Sidekiq::Testing.inline! do
        ProductUpdateJob.perform_later
      end

      product1.reload
      product2.reload
      product_without_url.reload

      expect(product1.title).to eq("update title from sample title")
      expect(product2.title).to eq("update title from sample title")
      expect(product1.image.attached?).to eq true
      expect(product2.image.attached?).to eq true
      expect(product_without_url.image.attached?).to eq false
    end    
  end
end
