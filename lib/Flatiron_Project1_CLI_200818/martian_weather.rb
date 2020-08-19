require "pry"
require "net/http"
require "json"
# require "./lib/environment"


class MartianWeather
    attr_accessor :sol, :date, :season, :avgtemp, :hightemp, :lowtemp, :avgws, :highws, :lowws, :winddirection

    url = "https://api.nasa.gov/insight_weather/?api_key=dbgntr9dVwt1ol3Wdw5D8d7BTdEk5d208LElZEkA&feedtype=json&ver=1.0"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @@api_data = JSON.parse(response, symbolize_names: true)

    @@all = []

    def initialize
    end

    def self.create_instances
        @@api_data.each do |s| 
            if s[0] != :sol_keys
                if s[0] != :validity_checks
                    o = self.new
                    o.sol = s[0].to_s
                    o.date = s[1][:Last_UTC].split("T").first
                    o.season = s[1][:Season]
                    o.avgtemp = s[1][:AT][:av]
                    o.hightemp = s[1][:AT][:mx]
                    o.lowtemp = s[1][:AT][:mn]
                    o.avgws = s[1][:HWS][:av]
                    o.highws = s[1][:HWS][:mx]
                    o.lowws = s[1][:HWS][:mn]
                    o.winddirection = s[1][:WD][:most_common][:compass_point]
                    o.save
                end
            end
        end
    end

    def self.sort_by_date
        @@all.sort_by{|i| i.date}
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end


end

MartianWeather.create_instances
# binding.pry



