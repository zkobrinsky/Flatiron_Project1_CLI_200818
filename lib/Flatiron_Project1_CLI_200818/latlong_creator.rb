class LatLongCreator

    def self.create_latlong_from_zip(zip)
        url = "https://public.opendatasoft.com/api/records/1.0/search/?dataset=us-zip-code-latitude-and-longitude&q=#{zip}&facet=state&facet=timezone&facet=dst"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        @@api_data = JSON.parse(response, symbolize_names: true)
        unless @@api_data[:nhits] == 0
            latitude = @@api_data[:records].first[:fields][:latitude]
            longitude = @@api_data[:records].first[:fields][:longitude]
            city = @@api_data[:records].first[:fields][:city]
            state = @@api_data[:records].first[:fields][:state]
            latlong = [latitude, longitude, city, state]
        end
    end
end
