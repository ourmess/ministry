class Api::V1::ContributionsController < Api::V1::ApplicationController
  
  respond_to :json
  
  def create
    handle(201) do
      if params[:contribution_data]
        Contribution.create( contribution(params[:contribution_data]) )
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
      :participant_id => data[:participant_id],
      :category_name => data[:category_name],
      :full_res_url => data[:full_res_url],
      :low_res_url => data[:low_res_url],
      :keywords => [
        'trash'
      ],
      :location => [
        data[:lat],#34.052234,
        data[:lon]#-118.243685
      ]
    }
  end  
end