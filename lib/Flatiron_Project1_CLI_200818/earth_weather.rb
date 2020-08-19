require "pry"
require "net/http"
require "json"
require 'date'

class EarthWeather
    attr_accessor :lat, :long, :date, :season, :avgtemp, :hightemp, :lowtemp, :avgws, :highws, :lowws, :winddirection
    attr_reader :api_data

    
    @@all = []
    

    def initialize
        @api_data = nil

        
        # get_data
        # binding.pry
    end

    def get_data(url)
        uri = URI(url)
        response = Net::HTTP.get(uri)
        @api_data = JSON.parse(response, symbolize_names: true)
        binding.pry
        # Time.at(1335437221)  returns UTC
        # Time.at(@@api_data[:hourly].first[:dt])
        # Time.at(@@api_data[:current][:dt])
    end

    def self.create_instances(lat,long)
        i = 0
        6.times do
            time = (Time.now - (86400*i)).to_i
            o = self.new
            url = "http://api.openweathermap.org/data/2.5/onecall/timemachine?lat=#{lat}&lon=#{long}&dt=#{time}&appid=3ef2f9e27db06e5523669088cdd44570"
            o.get_data(url)
            i += 1
        end


    end

    def self.create_forecast_instances

    end

    
end

EarthWeather.create_instances(33.441792, -94.037689)