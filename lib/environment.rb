require "date"
require "pry"
require "net/http"
require "json"
require "time"
require 'sqlite3'

require "./lib/Flatiron_Project1_CLI_200818/cli"
require "./lib/Flatiron_Project1_CLI_200818/earth_weather"
require "./lib/Flatiron_Project1_CLI_200818/martian_weather"
require "./lib/Flatiron_Project1_CLI_200818/latlong_creator"



# DB = {:conn => SQLite3::Database.new("db/weather_data.db")}


# sql = <<-SQL
#     CREATE TABLE IF NOT EXISTS martian_weather (
# 	"id"	INTEGER,
# 	"avgtemp"	INTEGER,
# 	"date"	TEXT,
# 	"hightemp"	INTEGER,
# 	"highws"	INTEGER,
# 	"lowtemp"	INTEGER,
# 	"lowws"	INTEGER,
# 	"pres"	REAL,
# 	"season"	TEXT,
# 	"sol"	TEXT,
# 	"winddir"	TEXT,
# 	PRIMARY KEY("id")
# )
# SQL


# DB[:conn].execute(sql)
