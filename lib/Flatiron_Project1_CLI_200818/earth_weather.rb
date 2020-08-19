require "pry"
require "net/http"
require "json"
require 'date'

class EarthWeather
    attr_accessor :lat, :long, :date, :season, :avgtemp, :hightemp, :lowtemp, :avgws, :highws, :lowws, :winddirection
    attr_reader :api_data

    
    @@all = []
    @@api_data = nil
    

    def initialize
        

        
        # get_data
        # binding.pry
    end

    def get_data(url)
        uri = URI(url)
        response = Net::HTTP.get(uri)
        @@api_data = JSON.parse(response, symbolize_names: true)
        # binding.pry
        # Time.at(1335437221)  returns UTC
        # Time.at(@api_data[:current][:dt])
        Time.at(@@api_data[:current][:dt]).to_s.split(" ").first
    end

    def self.create_instances(lat,long)
        # binding.pry
        i = 0
        6.times do
            time = (Time.now - (86400*i)).to_i
            o = self.new
            url = "http://api.openweathermap.org/data/2.5/onecall/timemachine?lat=#{lat}&lon=#{long}&dt=#{time}&appid=3ef2f9e27db06e5523669088cdd44570"
            o.get_data(url)
            # binding.pry
            o.date = Time.at(@@api_data[:current][:dt]).to_s.split(" ").first
            o.season = o.get_season(Time.at(@@api_data[:current][:dt]))
            o.lat = lat
            o.long = long
            
            
            binding.pry

                
            i += 1
        end

    end




    def self.create_forecast_instances

    end

    def get_season(date)
        #found at https://stackoverflow.com/questions/15414831/ruby-determine-season-fall-winter-spring-or-summer
        #code by stbnrivas
        year_day = date.yday().to_i
        year = date.year.to_i
        is_leap_year = year % 4 == 0 && year % 100 != 0 || year % 400 == 0
        if is_leap_year and year_day > 60
          # if is leap year and date > 28 february 
          year_day = year_day - 1
        end
  
        if year_day >= 355 or year_day < 81
          result = "winter"
        elsif year_day >= 81 and year_day < 173
          result = "spring"
        elsif year_day >= 173 and year_day < 266
          result = "summer"
        elsif year_day >= 266 and year_day < 355
         result = "autumn"
        end
  
        return result
      end


    
end

EarthWeather.create_instances(33.441792, -94.037689)


