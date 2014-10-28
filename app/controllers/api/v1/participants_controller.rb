class Api::V1::ParticipantsController < Api::V1::ApplicationController
  
  respond_to :json
  
  def create
    handle(201) do
      if params[:user_data]
        user_data = JSON.parse( params[:user_data] )
        first_name = user_data['first_name']
        last_name = user_data['first_name']
        @p = Participant.where(:first_name => first_name, :last_name => last_name).first
        if @p.size==0
          @p = Participant.new(:first_name => first_name, :last_name => last_name)
          @p.save!
          #Participant.where(:user_id => "53fd6b6d4d6f64df30000000").in(:keywords => ['anal','butst'])
          #Participant.where(:location.near => [-73.935833, 44.106667]).count
          #Participant.where(:full_res_url => "we").geo_near([-73.935833, 43]).execute["results"].size
          #Participant.where(:full_res_url => "we").geo_near([-73.935833, 44]).max_distance(5).execute["results"]
        end
        "{\"auth\":\"success\"}"
      else
        "{\"auth\":\"fail\"}"
      end
    end
  end

  def find_all
    handle(200) do
      Participant.all
    end
  end

 private
  def participant
  end
  
end