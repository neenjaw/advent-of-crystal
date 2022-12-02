require "./advent_of_crystal/client"
require "./advent_of_crystal/common"
require "./advent_of_crystal/config"
require "./advent_of_crystal/exception"
require "./advent_of_crystal/input"
require "./advent_of_crystal/solution_cache"
require "./advent_of_crystal/submitter"

require "./advent_of_crystal/approach/**"
require "./advent_of_crystal/solutions/**"

module AdventOfCrystal
  VERSION = "0.1.0"

  def self.start
    year = ARGV[0].to_i
    day = ARGV[1].to_i
    data = Input.new(year, day)
    submitter = Submitter.new(year, day)
  end
end
