require "pry"
require "net/http"
require "json"
require "date"
require "time"
require_relative "./earth_weather"

# require "./lib/environment"


class MartianWeather
    attr_accessor :sol, :date, :season, :avgtemp, :hightemp, :lowtemp, :avgws, :highws, :lowws, :winddir, :pres

    url = "https://api.nasa.gov/insight_weather/?api_key=dbgntr9dVwt1ol3Wdw5D8d7BTdEk5d208LElZEkA&feedtype=json&ver=1.0"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @@api_data = JSON.parse(response, symbolize_names: true)

    @@all = []
    @@forecast = []

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
                    o.avgtemp = o.c_to_f(s[1][:AT][:av]).round()
                    o.hightemp = o.c_to_f(s[1][:AT][:mx]).round()
                    o.lowtemp = o.c_to_f(s[1][:AT][:mn]).round()
                    o.avgws = o.mps_to_mph(s[1][:HWS][:av]).round()
                    o.highws = o.mps_to_mph(s[1][:HWS][:mx]).round()
                    o.lowws = o.mps_to_mph(s[1][:HWS][:mn]).round()
                    o.winddir = s[1][:WD][:most_common][:compass_point]
                    o.pres = o.pa_to_hpa(s[1][:PRE][:av]).round(2)
                    o.save
                end
            end
        end
    end

    def self.get_current_sol
        today_sol = @@all.last.sol.to_i + (Time.now.yday - Time.parse(@@all.last.date).yday) + 1
    end

    def self.create_forecast
        #dependent on .create_instances having been called
        @@all.each.with_index(1) do |d, i|
            o = self.new
            o.sol = get_current_sol+i
            o.date = (Time.now+86400*i).to_s.split(" ").first
            o.season = EarthWeather.new.get_season(Time.parse(o.date))
            binding.pry
            

        end
    end

#     [10] pry(MartianWeather)> Time.now.yday
# => 233
# [11] pry(MartianWeather)> Time.parse("2020-08-09T21:00:49Z").yday
# => 222
# [12] pry(MartianWeather)> Time.now.yday-Time.parse("2020-08-09T21:00:49Z").yday

    def self.sort_by_date
        @@all.sort_by{|i| i.date}
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

    def self.forecast
        @@forecast
    end

    def pa_to_hpa(pa)
        pa/100
    end

    def c_to_f(c)
        (c*9/5)+32
    end

    def mps_to_mph(m)
        m*2.237
    end


end

MartianWeather.create_instances
MartianWeather.create_forecast

# binding.pry



