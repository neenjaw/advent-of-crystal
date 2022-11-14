require "json"

require "./common"
require "./solution_cache/results"

class AdventOfCrystal::SolutionCache
  CACHE_FILE = Path.new(Dir.current, "cache.json")

  getter day : Int32
  getter year : Int32
  getter cache : SolutionCache::Results

  def initialize(@year : Int32, @day : Int32, @persist = true)
    if cache_exists? && @persist
      @cache = deserialize_cache_file
    else
      @cache = SolutionCache::Results.new
      serialize_cache_file if @persist
    end
  end

  def get(part : ProblemPart, answer : String) : TestResult?
    cache.by_year[year]?
      .try &.by_day[day]?
        .try &.by_part[part]
          .try &.find { |test_result| test_result.answer === answer }
  end

  def set(part : ProblemPart, answer : String, message : String, correct : Bool)
    return get(part, answer) if has?(part, answer)

    test_result = TestResult.new(year, day, part, answer, message, correct)

    cache.by_year[year] ||= YearResults.new
    cache.by_year[year].by_day[day] ||= DayResults.new(year, day)
    cache.by_year[year].by_day[day].by_part[part] ||= [] of TestResult
    cache.by_year[year].by_day[day].by_part[part] << test_result
    serialize_cache_file if @persist

    test_result
  end

  def has?(part : ProblemPart, answer : String) : Bool
    day_part_results = cache.by_year[year]?.try &.by_day[day]?.try &.by_part[part]
    return false if !day_part_results

    day_part_results.any? { |result| result.answer === answer }
  end

  private def deserialize_cache_file
    SolutionCache::Results.from_json(File.read(CACHE_FILE))
  end

  private def serialize_cache_file
    serialized = JSON.build do |json|
      cache.to_json(json)
    end

    File.write(CACHE_FILE, serialized)
  end

  private def cache_exists?
    File.exists?(CACHE_FILE)
  end
end
