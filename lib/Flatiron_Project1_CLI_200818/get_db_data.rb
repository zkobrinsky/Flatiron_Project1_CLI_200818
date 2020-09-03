class Get_DB_Data
    def self.get_martian_data
        weather_data = []
        sql = <<-SQL
        SELECT * FROM martian_weather
        SQL
        DB[:conn].execute(sql).each do |d|
            weather_hash = {}
            d.each_with_index do |w, i|
                weather_hash[DB[:conn].execute('PRAGMA table_info(martian_weather)')[i][1].to_sym] = w
            end
            weather_data << weather_hash
        end
        weather_data
    end

end