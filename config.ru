# frozen_string_literal: true
# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'bundler'
Bundler.require

unless Sinatra::Base.production?
  require 'dotenv'
  Dotenv.load
end

# Load app
require 'aa_service_bus'
run AaServiceBus
