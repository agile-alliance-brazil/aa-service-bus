# frozen_string_literal: true
# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'bundler'
Bundler.require

require 'dotenv'
Dotenv.load

# Load app
require 'aa_service_bus'
run AaServiceBus
