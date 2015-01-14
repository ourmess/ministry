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

  	data = {}
  	CSV.foreach("#{Rails.root}/lib/tasks/data/#{ENV['DATA']}", :headers => true) do |row|

  	  mh_id = row["Location"].split(" ")[1] #"MH SA54 2815 41st Ave"
  	  if mh_id.size!=4
  	  	mh_id = row["Location"].split(" ")[1] + row["Location"].split(" ")[2]
  	  end
  	  puts "Obtained mh_id: #{mh_id} from location string"

      data[mh_id] = {
      	:hadronex_id => row["Location ID"],
      	:hadronex_location => row["Location"],
      	:record_date => row["Date"],
      	:inches_from_sensor => row["Inches From Sensor"]
      }
  	end

  	puts "Begin iterating #{data}"

  	data.each_with_index do |(key, value),i|
  	  fs.query_by_mh_id(key)["objectIds"].each do |obj|
  	  	puts "Updating OBJECTID: #{obj}, mh_id: #{key}"
  	  	updates = [
  	  	  {
  	  	  	attributes: {
  	  	  	  OBJECTID: obj,
  	  	  	  hadronex_id: value[:hadronex_id],
  	  	  	  hadronex_location: value[:hadronex_location],	
  	  	  	  record_date: value[:record_date],
  	  	  	  inches_from_sensor: value[:inches_from_sensor]
  	  	  	}
  	  	  }
  	  	]
  	  	puts updates
  	  	fs.apply_edits([],updates)
  	  end
  	end

  end
end