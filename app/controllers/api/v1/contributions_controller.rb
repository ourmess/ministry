class Api::V1::ContributionsController < Api::V1::ApplicationController
  
  respond_to :json
  
  def all
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
  
end