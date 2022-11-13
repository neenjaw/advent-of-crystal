require "http"
require "uri"

require "./config"

class AdventOfCodeClient
  AOC_SCHEME            = "https"
  AOC_HOST              = "adventofcode.com"
  AOC_PUZZLE_PATH       = "/%<year>d/day/%<day>d"
  AOC_PUZZLE_INPUT_PATH = "/input"

  getter stored_cookies : Hash(String, String)

  def initialize
    @stored_cookies = Config.new.read_cookies
  end

  def get_input(day : Int32, year : Int32) : String
    path = (AOC_PUZZLE_PATH + AOC_PUZZLE_INPUT_PATH) % {year: year, day: day}
    uri = URI.new scheme: AOC_SCHEME, host: AOC_HOST
    client = HTTP::Client.new uri
    response = client.get path: path, headers: get_header

    unless response.status.ok?
      raise "Failed to get input for #{year} day #{day}"
    end

    response.body
  end

  private def get_header
    cookies = stored_cookies.reduce(HTTP::Cookies.new) do |cookies, (name, value)|
      cookie = HTTP::Cookie.new name: name, value: value
      cookies << cookie
      cookies
    end
    cookies.add_request_headers(HTTP::Headers.new)
  end
end
