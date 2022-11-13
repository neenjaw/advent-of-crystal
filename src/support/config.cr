require "ini"

class Config
  DEFAULT_PATH = Path.new(__DIR__, "support.ini")

  getter file_path : Path

  def initialize(file_path : Path = DEFAULT_PATH)
    @file_path = file_path
  end

  def read_cookies : Hash(String, String)
    read_config["cookie"]
  end

  private def read_config
    unless File.exists?(file_path)
      raise "ini not found at #{file_path}"
    end

    INI.parse(File.read(file_path))
  end
end
