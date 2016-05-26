# frozen_string_literal: true
require 'csv'

class AgileAllianceService
  def self.aa_member?(email, api_token)
    params = "<?xml version='1.0' encoding='UTF-8'?><data><api_key>#{api_token}</api_key><email>#{email}</email></data>"
    http = Net::HTTP.new(ENV['AA_API_HOST'])
    http.open_timeout = 5
    http.read_timeout = 5
    response = http.post('/api/', params)
    hash = Nokogiri.parse(response.body)
    return true if hash && hash.at('data') && hash.at('data').at('result').try(:text) == '1'
    false
  rescue Net::OpenTimeout
    check_csv(email)
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
