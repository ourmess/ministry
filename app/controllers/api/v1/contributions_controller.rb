require 'json'

class Api::V1::ContributionsController < Api::V1::ApplicationController

  respond_to :json

  def create_asset
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
              DESCRIPTION: "desc",
              LOCATION: "location",
              NAME: "name",
            }
          }
        ]

        fs.apply_edits(adds)

        Contribution.create( contribution(payload) )
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
