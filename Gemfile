source 'https://rubygems.org/'

ruby '2.5.1'

gem 'sinatra', '>= 2.0.3'
gem 'sinatra-contrib', '>= 2.0.3'
gem 'nokogiri', '>= 1.10.5'
gem 'activesupport', '>= 5.2.1'
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
  gem 'rack-test', '>= 1.1.0'
end

group :test do
  gem 'webmock'
end
