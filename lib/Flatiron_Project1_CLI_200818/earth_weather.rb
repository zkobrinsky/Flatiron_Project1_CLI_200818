require "pry"
require "net/http"
require "json"

class EarthWeather

    url = ""
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @@api_data = JSON.parse(response, symbolize_names: true)

    binding.pry

    def get_lat_longs

    end

    
end