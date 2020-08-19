require "pry"
require "net/http"
require "json"
# require 'date'

class EarthWeather
    attr_accessor :lat, :long, :date, :season, :avgtemp, :hightemp, :lowtemp, :avgws, :highws, :lowws, :winddir, :city, :state, :status, :pres
    attr_reader :api_data

    
    @@all = []
    @@api_data = nil
    

    def initialize
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

    def get_data(url)
        uri = URI(url)
        response = Net::HTTP.get(uri)
        @@api_data = JSON.parse(response, symbolize_names: true)
        Time.at(@@api_data[:current][:dt]).to_s.split(" ").first # Time.at(1335437221)  returns UTC
    end

    def self.create_instances(lat,long, city, state)
        @@all = [] #only storing one zip at a time, clears all
        i = 0
        6.times do
            time = (Time.now - (86400*i)).to_i
            o = self.new
            url = "http://api.openweathermap.org/data/2.5/onecall/timemachine?lat=#{lat}&lon=#{long}&units=imperial&dt=#{time}&appid=3ef2f9e27db06e5523669088cdd44570"
            o.get_data(url)
            o.date = Time.at(@@api_data[:current][:dt]).to_s.split(" ").first
            o.season = o.get_season(Time.at(@@api_data[:current][:dt]))
            o.lat = lat
            o.long = long
            o.city = city
            o.state = state
            o.winddir = o.convert_wind_deg_to_dir(@@api_data[:current][:wind_deg])
            o.avgtemp = @@api_data[:current][:temp]
            o.status = @@api_data[:current][:weather].first[:description]
            o.avgws = @@api_data[:current][:wind_speed]
            o.pres = @@api_data[:current][:pressure]

            # binding.pry

                o.save
            i += 1
        end
        # binding.pry

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

      def convert_wind_deg_to_dir(degrees)
        d = 22.5
        winddir = ""
        case
            when degrees <= d
                winddir = "N"
            when degrees < d*2 && degrees >= d
                winddir = "NNE"
            when degrees < d*3 && degrees >= d*2
                winddir = "NE"
            when degrees < d*4 && degrees >= d*3
                winddir = "ENE"
            when degrees < d*5 && degrees >= d*4
                winddir = "E"
            when degrees < d*6 && degrees >= d*5
                winddir = "ESE"
            when degrees < d*7 && degrees >= d*6
                winddir = "SE"
            when degrees < d*8 && degrees >= d*7
                winddir = "SSE"
            when degrees < d*9 && degrees >= d*8
                winddir = "S"
            when degrees < d*10 && degrees >= d*9
                winddir = "SSW"
            when degrees < d*11 && degrees >= d*10
                winddir = "SW"
            when degrees < d*12 && degrees >= d*11
                winddir = "WSW"
            when degrees < d*13 && degrees >= d*12
                winddir = "W"
            when degrees < d*14 && degrees >= d*13
                winddir = "WNW"
            when degrees < d*15 && degrees >= d*14
                winddir = "NW"
            when degrees < d*16 && degrees >= d*15
                winddir = "NNW"
            when degrees >= d*16
                winddir = "N"
        end
        winddir
      end


    
end

EarthWeather.create_instances(33.441792, -94.037689, "Fargo", "ND")


