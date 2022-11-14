require "./advent_of_crystal/input_data"
require "./advent_of_crystal/solution_submitter"

class AdventOfCrystal
  VERSION = "0.1.0"

  def initialize
    year = ARGV[0].to_i
    day = ARGV[1].to_i
    @data = InputData.new(year, day)
    @submitter = SolutionSubmitter.new(year, day)
  end
end

AdventOfCrystal.new
