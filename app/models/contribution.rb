class Contribution
  include Mongoid::Document
  field :participant_id, type: String
  field :category_name, type: String
  field :full_res_url, type: String
  field :low_res_url, type: String
  field :feature_server_url, type: String
  field :keywords, type: Array
  field :location, type: Array

  index({location: "2d"})

  def adds

  end
end
