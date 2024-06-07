require 'net/http'
require 'json'

class EbayService
  EBAY_APP_ID = ENV['EBAY_CLIENT_ID']

  def self.search_items(query)
    # Set up eBay Finding API URL and parameters
    url = URI('https://svcs.ebay.com/services/search/FindingService/v1')
    query_params = {
      'OPERATION-NAME' => 'findItemsByKeywords',
      'SERVICE-VERSION' => '1.0.0',
      'SECURITY-APPNAME' => EBAY_APP_ID,
      'RESPONSE-DATA-FORMAT' => 'JSON',
      'GLOBAL-ID' => 'EBAY-IT',
      'keywords' => query # The item name to search for
    }
    
    # Encode the query parameters
    url.query = URI.encode_www_form(query_params)

    # Make the API request
    response = Net::HTTP.get(url)

    puts(response)

    # Parse the JSON response
    result = JSON.parse(response)

    # Check for errors in the response
    if result.dig('findItemsByKeywordsResponse', 0, 'ack', 0) == 'Failure'
      Rails.logger.error "eBay API Error: #{result.dig('findItemsByKeywordsResponse', 0, 'errorMessage', 0, 'error', 0, 'message', 0)}"
      return []
    end

    # Extract relevant information from the response
    items = result.dig('findItemsByKeywordsResponse', 0, 'searchResult', 0, 'item') || []

    puts(items)

    items
  end
end
