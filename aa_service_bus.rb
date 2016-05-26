# frozen_string_literal: true

require './app/services/agile_alliance_service.rb'
require 'sinatra/config_file'
require 'nokogiri'
require 'json'

class AaServiceBus < Sinatra::Base
  register Sinatra::ConfigFile

  set public_folder: 'public', static: true

  get '/' do
    erb :welcome
  end

  get '/check_member/:email' do
    content_type :json
    return 401 unless authorized?
    if AgileAllianceService.aa_member?(params['email'], api_token)
      { member: true }.to_json
    else
      { status: 200, member: false }.to_json
    end
  end

  private

  helpers do
    def authorized?
      env['HTTP_AUTHORIZATION'] && env['HTTP_AUTHORIZATION'] == api_token
    end
  end

  def api_token
    @api_token ||= ENV['API_TOKEN']
  end
end
