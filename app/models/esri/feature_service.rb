require 'httparty'
require 'json'

module Esri
  class FeatureService
  	include HTTParty

  	def initialize(path, options={})
  	  @path = path
  	  @option = options
  	end

  	def coordinate_system
  	  @coordinate_system ||= JSON.parse( self.class.get("#{@path}?f=pjson").body )["extent"]
  	  #@coordinate_system["spatialReference"]["wkid"]
  	end

	
    def query_by_psr(psr)
      #q = {:psr => "3783", :returnGeometry => "true", :returnIdsOnly => "true", :f => "pjson"}
      JSON.parse( self.class.get("#{@path}/query?where=psr+%3D+#{psr}&returnGeometry=true&returnIdsOnly=true&f=pjson").response.body )
    end

    def query_by_mh_id(mh_id)
      #q = {:psr => "3783", :returnGeometry => "true", :returnIdsOnly => "true", :f => "pjson"}
      JSON.parse( self.class.get("#{@path}/query?where=mh_id+%3D+'#{mh_id}'&returnGeometry=true&returnIdsOnly=true&f=pjson").response.body )
    end

  	def apply_edits(adds=[], updates=[], deletes=[])
  	  options = { body: { f: 'json', rollbackOnFailure: 'true' } }
  	  options[:body].merge! ({adds: adds.to_json}) if adds.any?
      options[:body].merge! ({updates: updates.to_json}) if updates.any?
      options[:body].merge! ({deletes: deletes.to_json}) if deletes.any?
  	  self.class.post("#{@path}/applyEdits", options)
  	end

  end
end
