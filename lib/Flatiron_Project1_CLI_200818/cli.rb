require "pry"
require "net/http"
require "json"
require_relative "./latlong_creator"

class CLI

    attr_reader :lat, :long, :city, :state, :zip
    
    def initialize
        welcome
        get_valid_zip
        EarthWeather.new(@lat, @long)
    end


    def welcome
        puts "Welcome to the Martian Weather Service."
        5.times {loading}
        print "\n"
    end

    def loading
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
        # binding.pry
        until get_latlong(input) != nil && input.to_s.length == 5
            puts "Please enter a valid U.S. zip code."
            input = gets.chomp.to_i
        end
        # puts "latitude: #{@lat}, longitude: #{@long}, city: #{@city}, state: #{@state}"
    end

end







CLI.new