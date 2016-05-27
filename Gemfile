source 'https://rubygems.org/'

ruby '2.3.1'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'nokogiri'
gem 'httparty'

group :test, :development do
  gem 'rspec'
  gem 'rspec-collection_matchers'
  gem 'rubocop'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'brakeman'
  gem 'dotenv'
  gem 'brakeman', require: false
end

group :development do
  gem 'rake', '~> 10.0'
  gem 'minitest', '~> 5.2'
  gem 'rack-test', '~> 0.6'
end

group :test do
  gem 'webmock'
  gem 'codeclimate-test-reporter', require: nil
end
