require "http"
require "uri"
require "json"

require "./config"

enum ProblemPart
  A = 1
  B = 2
end

class AdventOfCodeClient
  AOC_SCHEME             = "https"
  AOC_HOST               = "adventofcode.com"
  AOC_PUZZLE_PATH        = "/%<year>d/day/%<day>d"
  AOC_PUZZLE_INPUT_PATH  = "/input"
  AOC_PUZZLE_SUBMIT_PATH = "/answer"

  getter stored_cookies : Hash(String, String)

  def initialize
    @stored_cookies = Config.new.read_cookies
  end

  def get_input(day : Int32, year : Int32) : String
    path = (AOC_PUZZLE_PATH + AOC_PUZZLE_INPUT_PATH) % {year: year, day: day}
    uri = URI.new scheme: AOC_SCHEME, host: AOC_HOST
    client = HTTP::Client.new uri
    response = client.get(path: path, headers: get_headers)

    unless response.status.ok?
      raise "Failed to get input for #{year} day #{day}"
    end

    response.body
  end

  def post_solution(day : Int32, year : Int32, part : ProblemPart, value : Value) : String
    path = (AOC_PUZZLE_PATH + AOC_PUZZLE_SUBMIT_PATH) % {year: year, day: day}
    uri = URI.new scheme: AOC_SCHEME, host: AOC_HOST
    client = HTTP::Client.new uri
    client.post(path: path, headers: post_headers, form: get_form_encoded(part, value)) do |response|
      raise "Unable to post response" if !response.status.ok?

      response.body_io.gets_to_end
    end
  end

  private def get_headers
    add_cookie(HTTP::Headers.new)
  end

  private def post_headers
    headers = HTTP::Headers.new
    headers.add("accept", "text/html")
    headers.add("user-agent", "advent of code submitter")
    add_cookie(headers)
  end

  private def add_cookie(headers : HTTP::Headers)
    cookies = stored_cookies.reduce(HTTP::Cookies.new) do |cookies, (name, value)|
      cookie = HTTP::Cookie.new name: name, value: value
      cookies << cookie
      cookies
    end
    cookies.add_request_headers(headers)
  end

  private def get_form_encoded(level : ProblemPart, answer : Value) : String
    "level=#{level.value}&answer=#{answer}"
  end
end

p AdventOfCodeClient.new.post_solution(1, 2018, ProblemPart::A, 1)
