source 'https://rubygems.org/'

ruby '2.5.1'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'nokogiri', '>= 1.10.4'
gem 'httparty'

group :test, :development do
  gem 'rspec'
  gem 'rspec-collection_matchers'
  gem 'rubocop'
  gem 'simplecov', require: false
  gem 'dotenv'
  gem 'brakeman', require: false
end

group :development do
  gem 'rake'
  gem 'minitest'
  gem 'rack-test'
end

group :test do
  gem 'webmock'
end
