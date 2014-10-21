class Asset
  include Mongoid::Document
  field :name, type: String
  field :type_id, type: Moped::BSON::ObjectId
end
