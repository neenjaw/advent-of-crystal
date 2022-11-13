require "./advent_of_code_client"
require "./problem_part_enum"
require "./solution_cache"

class SolutionSubmitter
  getter day : Int32
  getter year : Int32
  getter cache : SolutionCache?

  def initialize(
    @year : Int32,
    @day : Int32,
    @cache : SolutionCache? = nil
  )
    @cache ||= SolutionCache.new(@year, @day)
  end

  def submit(part : ProblemPart, answer : String)
    return cache.get(part, answer) if cache.has?(part, answer)

    result = AdventOfCodeClient.new.post_solution day: day, year: year, part: part, answer: answer

    cache.set(result)
  end
end
