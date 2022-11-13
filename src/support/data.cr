require "http"
require "uri"

require "./config"

class Data
  AOC_SCHEME            = "https"
  AOC_HOST              = "adventofcode.com"
  AOC_PUZZLE_PATH       = "/%<year>d/day/%<day>d"
  AOC_PUZZLE_INPUT_PATH = "/input"

  AOC_INPUT_FILE_NAME = "input.txt"

  getter stored_cookies : Hash(String, String)
  getter day : Int32
  getter year : Int32

  def initialize(day : Int32, year : Int32 = 2022)
    @stored_cookies = Config.new.read_cookies
    @day = day
    @year = year
  end

  def get_input
    return read_cache if cached?

    path = (AOC_PUZZLE_PATH + AOC_PUZZLE_INPUT_PATH) % {year: year, day: day}
    uri = URI.new scheme: AOC_SCHEME, host: AOC_HOST
    client = HTTP::Client.new uri
    response = client.get path: path, headers: get_header

    unless response.status.ok?
      raise "Failed to get input for #{year} day #{day}"
    end

    create_cache(response.body)
  end

  private def cached? : Bool
    p File.exists? cache_file_path
  end

  private def read_cache : String
    p File.read cache_file_path
  end

  private def cache_file_path : Path
    Path.new(Dir.current, "resources", year.to_s, day.to_s, AOC_INPUT_FILE_NAME)
  end

  private def create_cache(content : String) : String
    unless Dir.exists? cache_file_path.dirname
      Dir.mkdir_p(cache_file_path.dirname)
    end

    File.write(cache_file_path, content)
    content
  end

  private def get_header
    headers = HTTP::Headers.new
    cookies = stored_cookies.reduce(HTTP::Cookies.new) do |cookies, (name, value)|
      cookie = HTTP::Cookie.new name: name, value: value
      cookies << cookie
      cookies
    end
    cookies.add_request_headers(headers)
  end
end

p Data.new(day: 1, year: 2021).get_input
