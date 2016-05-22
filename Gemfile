source 'https://rubygems.org/'

ruby '2.3.1'

gem 'sinatra', '~> 1.4'

group :test, :development do
  gem 'rspec'
  gem 'rspec-collection_matchers'
  gem 'rubocop'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'brakeman'
end

group :development do
  gem 'rake', '~> 10.0'
  gem 'minitest', '~> 5.2'
  gem 'rack-test', '~> 0.6'
end
