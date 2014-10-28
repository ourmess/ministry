class Api::V1::AssetsController < Api::V1::ApplicationController
  
  respond_to :json
  
  def find_all_by_coordinates
    handle(201) do
      if params[:data]
    	["3776","3777","3778","3779","3780","3781","3782","3783","3784","3785","3786","3787","3788","3789"]
      end
    end
  end

  def find_object_id_by_psr

  	handle(201) do
      if params[:data]
      	payload = JSON.parse( params[:data] )
      	
      	fs = Esri::FeatureService.new( payload["feature_service_url"] )
        puts "fs.coordinate_system", fs.coordinate_system
        
        psr = payload["psr"]
        
        puts psr
        
        fs.query(psr)["objectIds"]  
      end
    end

  end

end