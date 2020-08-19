require "pry"
require "net/http"
require "json"
require_relative "./latlong_creator"
require_relative "./martian_weather"
require_relative "./earth_weather"

class CLI

    attr_reader :lat, :long, :city, :state, :zip
    
    def initialize
        start
        binding.pry
    end

    def start
        welcome
        get_valid_zip
        EarthWeather.create_instances(@lat, @long, @city, @state)
        MartianWeather.create_instances
    end


    def welcome
        puts "Welcome to the Martian Weather Service."
        5.times {loading_dots}
        print "\n"
    end

    def loading_dots
        sleep(0.3)
        print "." 
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
            input = gets.chomp.to_i
        end
    end

end

CLI.new