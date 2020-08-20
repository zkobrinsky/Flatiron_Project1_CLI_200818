require "./lib/environment"

class EarthWeather
    attr_accessor :lat, :long, :date, :season, :avgtemp, :hightemp, :lowtemp, :avgws, :highws, :lowws, :winddir, :city, :state, :status, :pres
    attr_reader :api_data

    
    @@all = []
    @@forecast = []
    @@api_data = nil
    

    def initialize
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

    def self.get_data(url)
        uri = URI(url)
        response = Net::HTTP.get(uri)
        @@api_data = JSON.parse(response, symbolize_names: true)
    end

    def self.create_instances(lat,long, city, state)
        @@all = [] #only storing one zip at a time, clears all
        i = 0
        6.times do
            time = (Time.now - (86400*i)-1000).to_i #converts to unix #-1000 to account for difference in clocks, can't be in future
            o = self.new
            url = "http://api.openweathermap.org/data/2.5/onecall/timemachine?lat=#{lat}&lon=#{long}&units=imperial&dt=#{time}&appid=3ef2f9e27db06e5523669088cdd44570"
            #api call defaults units to imperial
            get_data(url)
            o.date = Time.at(@@api_data[:current][:dt]).to_s.split(" ").first
            o.season = o.get_season(Time.at(@@api_data[:current][:dt]))
            o.lat = lat
            o.long = long
            o.city = city
            o.state = state
            o.winddir = o.convert_wind_deg_to_dir(@@api_data[:current][:wind_deg])
            o.avgtemp = @@api_data[:current][:temp].round()
            o.status = @@api_data[:current][:weather].first[:description]
            o.avgws = @@api_data[:current][:wind_speed].round()
            o.pres = @@api_data[:current][:pressure]
            o.save
            i += 1
        end

    end

    def self.create_forecast(lat, long, city, state)
        @@forecast = []
        url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=imperial&exclude={part}&appid=3ef2f9e27db06e5523669088cdd44570"
        get_data(url)
        # @@api_data[:daily].shift
        @@api_data[:daily].each do |d|
            o = self.new
            o.date = Time.at(d[:dt]).to_s.split(" ").first
            o.season = o.get_season(Time.at(d[:dt]))
            o.lat = lat
            o.long = long
            o.city = city
            o.state = state
            o.winddir = o.convert_wind_deg_to_dir(d[:wind_deg])
            o.avgtemp = d[:temp][:day].round()
            o.hightemp = d[:temp][:max].round()
            o.lowtemp = d[:temp][:min].round()
            o.status = d[:weather].first[:description]
            o.avgws = d[:wind_speed].round()
            o.pres = d[:pressure]
            @@forecast << o
        end
        #api that previously made historical data and current did not include high/low temp
        #This extracts from this API, puts into current weather data, and removes itself from forecast
        @@all.first.hightemp = @@forecast.first.hightemp
        @@all.first.lowtemp = @@forecast.first.lowtemp
        @@forecast.shift
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

# EarthWeather.create_instances(33.441792, -94.037689, "Fargo", "ND")
# EarthWeather.create_forecast(33.441792, -94.037689, "Fargo", "ND")


