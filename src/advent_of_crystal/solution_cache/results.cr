require "json"

class AdventOfCrystal::SolutionCache
  class Results
    include JSON::Serializable

    property by_year : Hash(Int32, YearResults)

    def initialize(
      @by_year : Hash(Int32, YearResults) = Hash(Int32, YearResults).new
    )
    end
  end

  class YearResults
    include JSON::Serializable

    property by_day : Hash(Int32, DayResults)

    def initialize(
      @by_day : Hash(Int32, DayResults) = Hash(Int32, DayResults).new
    )
    end
  end

  class DayResults
    include JSON::Serializable

    property year : Int32
    property day : Int32
    property by_part : Hash(ProblemPart, Array(TestResult))

    def initialize(
      @year : Int32,
      @day : Int32,
      @by_part : Hash(ProblemPart, Array(TestResult)) = Hash(ProblemPart, Array(TestResult)).new
    )
    end
  end

  class TestResult
    include JSON::Serializable

    property year : Int32
    property day : Int32
    property part : ProblemPart
    property answer : String
    property response : String
    property correct : Bool

    def initialize(
      @year : Int32,
      @day : Int32,
      @part : ProblemPart,
      @answer : String,
      @response : String,
      @correct : Bool
    )
    end
  end
end
