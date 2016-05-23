# frozen_string_literal: true

require './app/services/agile_alliance_service.rb'
require 'sinatra/config_file'
require 'nokogiri'

class AaServiceBus < Sinatra::Base
  register Sinatra::ConfigFile

  set public_folder: 'public', static: true

  config_file './config/application.yml'

  get '/' do
    erb :welcome
  end

  get '/check_member/:email' do
    return 401 unless authorized?
    if AgileAllianceService.aa_member?(params['email'], api_token)
      { member: true }.to_json
    else
      { member: false }.to_json
    end
  end

  private

  helpers do
    def authorized?
      env['HTTP_AUTHORIZATION'] && env['HTTP_AUTHORIZATION'] == api_token
    end
  end

  def api_token
    @api_token ||= settings.api_token
  end
end
