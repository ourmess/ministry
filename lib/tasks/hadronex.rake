# 	consume csv
#   dedup records and get last water level reading for each pipe
#   find the object id using the manhole id
#   construct water level update payload for each manhole
#   post to contributions/create_manhole_water_level endpoint

namespace :hadronex do
  task :smart_manholes => :environment do

  	puts "Setting up WFS"
  	fs = Esri::FeatureService.new( "http://services3.arcgis.com/UyxiNa6T5RHXF0kI/arcgis/rest/services/SC_SmartManholes/FeatureServer/0" )

  	next if not ENV['DATA']
  	puts "Parsing CSV #{ENV['DATA']}"

    alarm_thresholds = {
      "2970" =>  8.0,
      "2973" =>  5.0,
      "2984" => 5.0,
      "3668" => 5.0,
      "3673" => 10.0,
      "6095" => 10.0
    }

  	data = {}
  	CSV.foreach("#{Rails.root}/lib/tasks/data/#{ENV['DATA']}", :headers => true) do |row|

  	  mh_id = row["Location"].split(" ")[1] #"MH SA54 2815 41st Ave"
  	  if mh_id.size!=4
  	  	mh_id = row["Location"].split(" ")[1] + row["Location"].split(" ")[2]
  	  end

      #update manhole only if next record contains measurement less than the previous 
      if data[mh_id]==nil || row["Inches From Sensor"].to_f<=data[mh_id][:inches_from_sensor].to_f
        current = data[mh_id][:inches_from_sensor] rescue row["Inches From Sensor"]
        puts "Updating mh_id: #{mh_id}  current:#{current}  next:#{row['Inches From Sensor']}"
        data[mh_id] = {
        	:hadronex_id => row["Location ID"],
        	:hadronex_location => row["Location"],
        	:record_date => row["Date"],
        	:inches_from_sensor => row["Inches From Sensor"]
        }
      end

  	end

  	puts "Begin iterating #{data}"

  	data.each_with_index do |(key, value),i|
  	  fs.query_by_mh_id(key)["objectIds"].each do |obj|
  	  	puts "Updating OBJECTID: #{obj}, mh_id: #{key}"

        #identify if the lowest measurment is in alarm state
        if alarm_thresholds[value[:hadronex_id]].to_f > value[:inches_from_sensor].to_f
          alarm = "true"
        else
          alarm = "false"
        end
        
  	  	updates = [
  	  	  {
  	  	  	attributes: {
  	  	  	  OBJECTID: obj,
  	  	  	  hadronex_id: value[:hadronex_id],
  	  	  	  hadronex_location: value[:hadronex_location],	
  	  	  	  record_date: value[:record_date],
  	  	  	  inches_from_sensor: value[:inches_from_sensor],
              alarm: alarm
  	  	  	}
  	  	  }
  	  	]
  	  	puts updates
  	  	fs.apply_edits([],updates)
  	  end
  	end

  end
end