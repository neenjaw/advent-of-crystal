require "./client"

class AdventOfCrystal::Input
  AOC_INPUT_FILE_NAME = "input.txt"

  getter day : Int32
  getter year : Int32

  def initialize(@year : Int32, @day : Int32)
  end

  def input : String
    return read_cache if cached?

    input = Client.new.get_input day: day, year: year

    create_cache(input)
  end

  private def cached? : Bool
    File.exists? cache_file_path
  end

  private def read_cache : String
    File.read cache_file_path
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
end
