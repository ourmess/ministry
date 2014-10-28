require 'json'

class Api::V1::ContributionsController < Api::V1::ApplicationController

  respond_to :json

  def create_sso
    handle(201) do
      if params[:data]
      
        payload = JSON.parse( params[:data] )

        fs = Esri::FeatureService.new( payload["feature_service_url"] )
        puts "fs.coordinate_system", fs.coordinate_system
        
        adds = [
          {
            geometry: {
              x: payload["lon"].to_f,
              y: payload["lat"].to_f
            },

            attributes: {
              lattitude_decimal_degrees: payload["lon"].to_f,
              longitude_decimal_degrees: payload["lat"].to_f,
              spill_type: "Category 3",
              region: payload["region"].to_i,
              #agency: payload["agency"],
              #collection_sys: payload["collection_sys"],
              #sso_event_id: payload["sso_event_id"],
              #start_dt: payload["start_dt"],
              #spill_address: payload["spill_address"],
              #spill_city: payload["spill_city"],
              #spill_zip: payload["spill_zip"].to_i,
              #county: payload["county"],
              #responsible_party: payload["responsible_party"],
              spill_poc_name: payload["spill_poc_name"],
              spill_vol: payload["spill_vol"],
              spill_vol_reach_surf: payload["spill_vol_reach_surf"],
              spill_vol_recover: payload["spill_vol_recover"]
            }
          }
        ]
        
        puts adds

        fs.apply_edits(adds)

        Contribution.create( contribution(payload) )
      end
    end
  end
  
  def create_cleaning_record
    handle(201) do
      if params[:data]
      
        payload = JSON.parse( params[:data] )

        fs = Esri::FeatureService.new( payload["feature_service_url"] )
        puts "fs.coordinate_system", fs.coordinate_system
        
        updates = [
          {
            attributes: {
              OBJECTID: payload["object_id"],
              clean_flush: payload["clean_flush"],
              cleaning_area: payload["cleaning_area"].to_i,
              cleaning_crew_1: payload["cleaning_crew_1"],
              cleaning_crew_2: payload["cleaning_crew_2"],
              vehicle_number: payload["vehicle_number"],
              hours: payload["hours"],
              date: payload["date"],
              comments: payload["comments"]
            }
          }
        ]

        fs.apply_edits([],updates)
        updates
      end
    end
  end

  def destroy
    handle(201) do
    end
  end

  def find_all
    handle(200) do
      Contribution.all
    end
  end

  def find_all_by_search_term
    handle(201) do
      if params[:search_data]
        search_data = params[:search_data]
        search_term = search_data[:search_term]
        lat,lon = Geocoder.coordinates(search_term)
        #check to see if we got lat, lon
        c = Contribution.geo_near([lat.to_f, lon.to_f]).execute["results"]
        {
          :center => {
            :lat => lat.to_f,
            :lon => lon.to_f
          },
          :markers => c
        }
      end
    end
  end

 private
  def contribution(data)
    {
      :participant_id => data["participant_id"],
      :category_name => data["category_name"],
      :full_res_url => data["full_res_url"],
      :low_res_url => data["low_res_url"],
      :feature_server_url => data["feature_server_url"],
      :keywords => [
        'trash'
      ],
      :location => [
        data["lat"].to_f,#34.052234,
        data["lon"].to_f#-118.243685
      ]
    }
  end
end
