# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Repositories', 'app/repositories'
  add_group 'Services', 'app/services'
  minimum_coverage 100
end
SimpleCov.command_name 'RSpec'

require './config/environment'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random

  Kernel.srand config.seed
end
