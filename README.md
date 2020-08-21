# Martian Weather Service

This gem compares real Martian Weather data collected from NASA's InSight Mars Lander on Elysium Planitia to your local weather via U.S. zip code (sorry rest of the world). It's deliberately campy with a little dark humor. When you first run it, don't worry, it's not broken. The terminal output is deliberately timed for dramatic effect.

This CLI gem takes in a U.S. zip code, gets the lat-long coordinates by using [this OpenDataSoft API](https://public.opendatasoft.com/explore/dataset/us-zip-code-latitude-and-longitude/api/), which can then be used to query Earth weather from [OpenWeatherData APIs](https://openweathermap.org/api). Upon initialize, Martian weather data is created using [Nasa's Mars InSight API](https://api.nasa.gov/assets/insight/InSight%20Weather%20API%20Documentation.pdf). Nasa has a [bunch of cool, free APIs](https://api.nasa.gov/), and to be honest, this project mostly stems from my desire to use some of their data. 

From there, you can use the CLI to view and compare Earth and Weather data in different ways.

## Usage

Just a stand-alone Ruby CLI app.

## Install Instructions
Git clone this repository.
Run bundle install.
Run the app using bin/run.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zkobrinsky/Flatiron_Project1_CLI_200818. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/Flatiron_Project1_CLI_200818/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FlatironProject1CLI200818 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/Flatiron_Project1_CLI_200818/blob/master/CODE_OF_CONDUCT.md).

## Acknowledgements
The #get_season method was repurposed from [this code by stbnrivas](https://stackoverflow.com/questions/15414831/ruby-determine-season-fall-winter-spring-or-summer), which converts dates into seasons. 
