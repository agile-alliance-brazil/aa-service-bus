# frozen_string_literal: true

require 'csv'
require 'active_support'
require 'active_support/core_ext/object'

class AgileAllianceService
  def self.aa_member?(email, api_token)
    response = request_information(api_token, email)
    if response.code == '200'
      hash = Nokogiri.parse(response.body)
      hash&.at('data') && hash.at('data').at('result').try(:text) == '1'
    else
      check_csv(email)
    end
  rescue Net::OpenTimeout
    check_csv(email)
  end

  def self.request_information(api_token, email)
    params = "<?xml version='1.0' encoding='UTF-8'?><data><api_key>#{api_token}</api_key><email>#{email}</email></data>"
    uri = URI.parse("#{ENV['AA_API_HOST']}/check-membership")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 5
    http.read_timeout = 5
    http.post(uri, params)
  end

  def self.check_csv(email)
    file = File.read('./app/data/20160515_Agile_Alliance_Members.csv', encoding: 'ISO-8859-1:UTF-8')
    file = file.tr("\r", '')

    CSV.parse(file, headers: true) do |row|
      return true if email == row['user_email']
    end

    false
  end
end
