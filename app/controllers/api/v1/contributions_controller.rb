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
              region: "region",
              agency: "agency",
              collection_sys: "collection_sys",
              sso_event_id: "sso_event_id",
              start_dt: "start_dt",
              spill_address: "server spill_address",
              spill_city: "server spill_city",
              spill_zip: "server spill_zip",
              county: "county?",
              spill_type: "Category 3", #Category 1, Category 2, Category 3
              responsible_party: "responsible_party",
              spill_poc_name: "spill_poc_name",
              lattitude_decimal_degrees: payload["lat"],
              longitude_decimal_degrees: payload["lon"],
              spill_vol: payload["spill_vol_reach_surf"],
              spill_vol_reach_surf: payload["spill_vol_reach_surf"],
              spill_vol_recover: payload["spill_vol_recover"]
            }
          }
        ]

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
              cleaned_2014: payload["cleaned_2014"]
            }
          }
        ]

        fs.apply_edits([],updates)
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
