class CLI

    attr_reader :lat, :long, :city, :state, :zip

    @@mars_forecast_switch = true
    
    def initialize
    end

    def start
        welcome
        get_valid_zip
        EarthWeather.create_instances(@lat, @long, @city, @state, @zip)
        MartianWeather.create_instances
        MartianWeather.create_forecast
        EarthWeather.create_forecast(@lat, @long, @city, @state, @zip)
        compare_current_weather_on_welcome
        main_menu
    end

    def debug
        @zip = 11218
        @lat = 40.644552
        @long = -73.97595
        @city = "Brooklyn"
        @state = "NY"
        EarthWeather.create_instances(@lat, @long, @city, @state, @zip)
        MartianWeather.create_instances
        MartianWeather.create_forecast
        EarthWeather.create_forecast(@lat, @long, @city, @state, @zip)
        main_menu
    end


    
    def loading_dots
        sleep(0.3)
        print "." 
    end


    def welcome
        puts "Welcome to the Martian Weather Service."
        sleep(0.6)
        7.times {loading_dots}
        sleep(0.3)
        print "Preparing quantum confibulators."
        sleep(0.8)
        print "\n"
        7.times {loading_dots}
        sleep(0.3)
        print "Charging atomic capacitors."
        sleep(1)
        print "\n"
        7.times {loading_dots}
        sleep(0.3)
        print "Transmitting to Mars."
        sleep(0.9)
        print "\n"
        7.times {loading_dots}
        sleep(0.3)
        puts "Extraterrestrial transmission received."
        print "\n"
        sleep(1)
    end
    
    def get_latlong(zip)
        latlong = LatLongCreator.create_latlong_from_zip(zip)
        if latlong != nil
            @lat = latlong[0]
            @long = latlong[1]
            @city = latlong[2]
            @state = latlong[3]
            @zip = zip
        else
            latlong = nil
        end
    end
        
    def get_valid_zip
        puts "Please enter your zip code."
        input = gets.chomp.to_i
        until get_latlong(input) != nil && input.to_s.length == 5
            puts "Please enter a valid U.S. zip code."
            print "\n"
            input = gets.chomp.to_i
        end
    end

    def diff_zip
        get_valid_zip
        EarthWeather.create_instances(@lat, @long, @city, @state, @zip)
        compare_current_weather
    end

    def compare_current_weather_on_welcome
        e = EarthWeather.all.first
        m = MartianWeather.all.first

        print "\n"
        puts "It is #{e.avgtemp}°F with #{e.status} in your beautiful city of #{e.city}."
        puts "The wind is #{e.avgws}mph to the #{e.winddir}, with a lovely atmospheric pressure of #{e.pres} hPa."
        sleep(7)
        print "\n"
        print "\n"
        puts "On Mars it is #{m.avgtemp}°F with a high of #{m.hightemp}°F and a low of #{m.lowtemp}°F."
        puts "The wind is #{m.avgws}mph to the #{m.winddir}, with an atmospheric pressure of #{m.pres} hPa."
        print "\n"
        print "\n"
        sleep(7)
        puts "It is cold."
        sleep(2)
        puts "It is desolate."
        sleep(2)
        puts "It is lonely."
        sleep(2)
        print "\n"
        5.times {loading_dots}
        sleep(2)
        print "\n"
        print "\n"
        puts "Where you are is beautiful."
        print "\n"
        sleep(2)
        puts "Cheer up."
        sleep(5)
        print "\n"
    end

    def compare_current_weather
        e = EarthWeather.all.first
        m = MartianWeather.all.first

        print "\n"
        puts "It is #{e.avgtemp}°F with #{e.status} in your beautiful city of #{e.city}."
        puts "The wind is #{e.avgws}mph from the #{e.winddir}, with a lovely atmospheric pressure of #{e.pres} hPa."
        print "\n"
        puts "On Mars it is #{m.avgtemp}°F with a high of #{m.hightemp}°F and a low of #{m.lowtemp}°F."
        puts "The wind is #{m.avgws}mph from the #{m.winddir}, with an atmospheric pressure of #{m.pres} hPa."
        print "\n"
        sleep(7)
        puts "Where you are is beautiful."
        print "\n"
        sleep(2)
        puts "Cheer up."
        print "\n"
        sleep(5)
        main_menu
        
    end

    def main_menu
        puts "Please select from the following options:"
        print "\n"
        puts "1. Change zip code"
        puts "2. Martian forecast"
        puts "3. Earth forecast"
        puts "4. Martian archived weather data"
        puts "5. Earth archived weather data"
        puts "6. Current Martian weather"
        puts "7. Current Earth weather"
        puts "8. Exit"


        input = gets.chomp.to_i
        while input < 1 || input > 8
            puts "Please enter a valid selection."
            input = gets.chomp.to_i
        end
            case input
                when 1
                    diff_zip
                when 2
                    martian_forecast
                when 3
                    earth_forecast
                when 4
                    martian_archive
                when 5
                    earth_archive
                when 6
                    current_martian
                when 7
                    current_earth
                when 8
                    exit
            end
    end

    def current_earth
        d = EarthWeather.all.first
        print "\n"
        puts "Current weather for #{@city}, #{@state}:"
        print "\n"
        puts "Earth date: #{d.date}, Average temp: #{d.avgtemp}°F, High temp: #{d.hightemp}°F, Low temp: #{d.lowtemp}°F."
            puts "Average wind speed: #{d.avgws}mph, Wind direction: #{d.winddir}, Atmospheric pressure: #{d.pres}hPa."
            puts "Season: #{d.season}, Status: #{d.status}."
            print "\n"
            main_menu
    end

    def current_martian
        sol = MartianWeather.get_current_sol
        d = MartianWeather.all.last
        print "\n"
        puts "Current weather on Mars:"
        print "\n"
        puts "Sol: #{sol}, Earth date: #{Time.now.to_s.split(" ").first}, Average temp: #{d.avgtemp}°F, High temp: #{d.hightemp}°F, Low temp: #{d.lowtemp}°F."
            puts "Average wind speed: #{d.avgws}mph, Wind direction: #{d.winddir}, Atmospheric pressure: #{d.pres}hPa."
            puts "Season: #{d.season}, Status: cold and desolate."
            print "\n"
            main_menu
    end

    def earth_archive
        print "\n"
        puts "Here is last week's weather for #{@city}, #{@state}:"
        print "\n"
        EarthWeather.all[1..-1].each do |d|
            puts "Earth date: #{d.date}, Average temp: #{d.avgtemp}°F."
            puts "Average wind speed: #{d.avgws}mph, Wind direction: #{d.winddir}, Atmospheric pressure: #{d.pres}hPa."
            puts "Season: #{d.season}, Status: #{d.status}."
            puts "-----------"
        end
        print "\n"
        main_menu
    end

    def martian_archive
        print "\n"
        puts "Here is the most recent Martian weather available:"
        print "\n"
        MartianWeather.all.reverse.each do |d|
            puts "Sol: #{d.sol}, Earth date: #{d.date}, Average temp: #{d.avgtemp}°F, High temp: #{d.hightemp}°F, Low temp: #{d.lowtemp}°F."
            puts "Average wind speed: #{d.avgws}mph, Wind direction: #{d.winddir}, Atmospheric pressure: #{d.pres}hPa."
            puts "Season: #{d.season}, Status: cold and desolate."
            puts "-----------"
        end
        print "\n"
        main_menu
    end

    def earth_forecast
        EarthWeather.create_forecast(@lat, @long, @city, @state, @zip)
        print "\n"
        puts "Here is your forecast for #{@city}, #{@state}:"
        print "\n"
        EarthWeather.forecast.each do |d|
            puts "Earth date: #{d.date}, Average temp: #{d.avgtemp}°F, High temp: #{d.hightemp}°F, Low temp: #{d.lowtemp}°F."
            puts "Average wind speed: #{d.avgws}mph, Wind direction: #{d.winddir}, Atmospheric pressure: #{d.pres}hPa."
            puts "Season: #{d.season}, Status: #{d.status}."
            puts "-----------"
        end
        print "\n"
        main_menu
    end

    def martian_forecast
        if @@mars_forecast_switch == true
            print "\n"
            print "Transmitting to ancient Martian oracles."
            10.times {loading_dots}
            print "\n"
            puts "Data received."
            print "\n"
            @@mars_forecast_switch = false
        end
        print "\n"
        puts "Here is your Martian forecast:"
        print "\n"
        MartianWeather.forecast.each do |d|
            puts "Sol: #{d.sol}, Earth date: #{d.date}, Average temp: #{d.avgtemp}°F, High temp: #{d.hightemp}°F, Low temp: #{d.lowtemp}°F."
            puts "Average wind speed: #{d.avgws}mph, Wind direction: #{d.winddir}, Atmospheric pressure: #{d.pres}hPa."
            puts "Season: #{d.season}, Status: cold and desolate."
            puts "-----------"
        end
        print "\n"
        main_menu
    end

end