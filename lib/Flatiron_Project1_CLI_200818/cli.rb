require "pry"
require "net/http"
require "json"
require_relative "./latlong_creator"

class CLI
    

    latlong = LatLongCreator.create_latlong_from_zip(zip)
    lat = latlong[0]
    long = latlong[1]
    city = latlong[2]
    state = latlong[3]

    binding.pry

end

CLI.new