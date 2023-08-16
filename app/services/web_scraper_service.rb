require 'nokogiri'
require 'open-uri'

class WebScraperService
  def initialize(url)
    @url = url
  end

  def scrape_data
    doc = Nokogiri::HTML(URI.open(@url))
    scraped_data = {}
    scraped_data.merge!({description: doc.at_css('h1 span:last-child').text})
    scraped_data.merge!({title: doc.at_css('h1 span:first-child').text})    
    scraped_data.merge!({price: doc.at_css('._30jeq3._16Jk6d').text.gsub("₹", "").gsub(",", "").to_i})
    scraped_data.merge!({url: @url})
    image_url = doc.at_css('img._396cs4')['src']    
    return {data: scraped_data, image_url: image_url}
  end
end