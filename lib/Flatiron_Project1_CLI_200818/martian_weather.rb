require "pry"
require "net/http"
require "json"


class MartianWeather
    attr_accessor :sol, :date, :season, :avgtemp, :hightemp, :lowtemp, :avgws, :highws, :lowws, :winddirection

    url = "https://api.nasa.gov/insight_weather/?api_key=dbgntr9dVwt1ol3Wdw5D8d7BTdEk5d208LElZEkA&feedtype=json&ver=1.0"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @@api_data = JSON.parse(response, symbolize_names: true)

    @@all = []

    def initialize
        @@api_data.each do |s| 
            self.new
            self.sol = s.first
            save
            binding.pry
        end
    end

    def save
        @@all << self
    end

end