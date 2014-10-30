class Asset
  include Mongoid::Document
  field :name, type: String
  field :type_id, type: Integer

  def reverse_geo_locate(lat,lon)
  	gc = Geocoder.search("#{lat},#{lon}").first
  	{
  	  "address" => "#{gc.street_address}",
  	  "city" => "#{gc.city}",
  	  "zip" => "#{gc.postal_code}",
  	  "county" => "#{gc.sub_state}"
  	}
  end
end
