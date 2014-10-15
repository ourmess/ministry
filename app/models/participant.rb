class Participant
  include Mongoid::Document
  field :first_name, type: String
  field :last_name, type: String
  field :feature_server_url, type: String
end
