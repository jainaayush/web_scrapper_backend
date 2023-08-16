class ProductUpdateJob < ApplicationJob
  queue_as :default

  def perform
    products = Product.where.not(url: nil)

    products.each do |product|
      update_product(product)
    end
  end

  private

  def update_product(product)
    begin
      scraped_data = scrape_product_data(product.url)
      product.update(scraped_data[:data])
      attach_product_image(product, scraped_data[:image_url])
    rescue StandardError => e
      log_error(product, e)
    end
  end

  def scrape_product_data(url)
    scraper = WebScraperService.new(url)
    scraper.scrape_data
  end

  def attach_product_image(product, image_url)
    return unless image_url.present?

    image_data = URI.open(image_url)
    product.image.attach(io: image_data, filename: 'product_image.jpg')
  end

  def log_error(product, error)
    Rails.logger.error("Error updating product ##{product.id}: #{error.message}")
  end
end