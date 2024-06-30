require 'net/http'
require 'json'

class DummyjsonService
  BASE_URL = 'https://dummyjson.com'

  def self.search_items(query)
    # Set up DummyJSON API URL and parameters
    url = URI("#{BASE_URL}/products/search")

    query_params = {
      'q' => query # The item name to search for
    }

    # Encode the query parameters
    url.query = URI.encode_www_form(query_params)

    # Make the API request
    response = Net::HTTP.get(url)

    puts(response)

    # Parse the JSON response
    result = JSON.parse(response)

    # Check for errors in the response
    if result['error']
      Rails.logger.error "DummyJSON API Error: #{result['error']}"
      return []
    end

    # Extract relevant information from the response
    items = result['products'] || []

    puts(items)

    items
  end
end