require 'faraday'
require 'pry'
require 'json'
require_relative 'weather.rb'

class City
  API_KEY = '30c63f8354237513'

  attr_accessor :name

  def initialize(name = gets.chomp)
    @name = name
  end

  def weather_now
    Weather.new(self, conditions['current_observation']['temp_c']).temp_c
  end

  def state
    conditions['current_observation']['display_location']['state_name']
  end

  private

  def conditions
    if @conditions.nil?
      response = connection.get("/api/#{API_KEY}/conditions/q/CA/#{name.gsub('-','_')}.json")
      @conditions = JSON.parse(response.body)
    else
      @conditions
    end
  end

  def connection
    @connection ||= Faraday.new(url: "http://api.wunderground.com") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end

city = City.new
puts city.state
puts city.weather_now