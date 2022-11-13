require "./client"
require "./problem_part_enum"
require "./solution_cache"

class SolutionSubmitter
  getter day : Int32
  getter year : Int32

  def initialize(
    @year : Int32,
    @day : Int32,
    @cache : SolutionCache? = nil
  )
  end

  def cache : SolutionCache
    @cache ||= SolutionCache.new(@year, @day)
  end

  def submit(part : ProblemPart, answer : String)
    return cache.get(part, answer) if cache.has?(part, answer)

    result = Client.new.submit_solution day: day, year: year, part: part, answer: answer

    cache.set(part, answer, result.message, result.correct)
  end
end

p SolutionSubmitter.new(2018, 1).submit(ProblemPart::A, "80")
