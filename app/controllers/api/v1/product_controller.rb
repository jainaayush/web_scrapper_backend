class Api::V1::ProductController < ApplicationController
  def index
    products = Product.all
    render :json => products
  end

  def scrape    
    url = params[:url]
        
    if url.present?      
      if product = Product.find_by_url(url)
        render json: product
      else
        scraper = WebScraperService.new(url)
        scraped_data = scraper.scrape_data
  
        # Add some error handling for creating the product
        begin          
          product = Product.new(scraped_data[:data])          
          if scraped_data[:image_url].present?
            image_data = URI.open(scraped_data[:image_url])
            product.image.attach(io: image_data, filename: 'product_image.jpg')
          end
          product.save
          render json: product
        rescue StandardError => e
          render json: { error: "Error creating the product: #{e.message}" }, status: :unprocessable_entity
        end
      end
    else
      render json: { error: "URL parameter is missing" }, status: :unprocessable_entity
    end
  end
    
end
