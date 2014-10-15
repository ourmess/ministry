class Api::V1::ApplicationController < ActionController::Base

  before_filter :determine_format

  private

  def handle(status=200, &block)
    begin
      render :json => block.call.to_json, :status => status
    rescue => e
      body = {:error => {:message => e.message, :exception => e.class.to_s}}
      Rails.logger.info(e.message)
      render :json => body.to_json, :status => 400
    end
  end

  def handle_basic(status=200, &block)
    begin
      render :text => block.call
    rescue => e
      puts "Failed handle_basic"
    end
  end

  def determine_format
    request.format = :json if (request.format == 'application/vnd.ourmess.ministry+json')
  end

end
