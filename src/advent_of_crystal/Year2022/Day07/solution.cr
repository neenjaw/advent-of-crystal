input_file = ARGV[0]
puts "📖 Reading #{input_file}:"

# File.each_line(input_file) do |line|
#   input << line
# end

class Parser
  @lines : Array(String)

  def initialize(lines)
    @lines = lines
  end

  def eat
    @lines.shift
  end

  def peek
    @lines.first
  end

  def done?
    @lines.empty?
  end

  def next_is_command?
    peek.starts_with?("$")
  end
end

instructions = File.read(input_file).chomp.split(/\n/)

class Commander
  def initialize
    @root = {} of {Symbol, String} => Hash
    @path = [] of String
    @pointer = @root
    @files = {} of {Symbol, String, Array(String)} => Int32
  end

  def handle_command(command, parser)
    if command.match(/\$ cd ([\/\w]+)/)
      change_directory($~[1])
    elsif command.match(/\$ ls/)
      list_directory(parser)
    end
  end

  def list_directory(parser)
    return if parser.next_is_command?

    a, b = parser.eat.strip.split(/ /)
    case a
    when "dir"
      @pointer[{:dir, b}] ||= {} of {Symbol, String} => Hash
    else
      @pointer[{:file, b}] ||= {} of {Symbol, String} => Hash
      @files[{:file, b, @path}] = a.to_i
    end

    list_directory(parser)
  end

  def change_directory(directory)
    case directory
    when ".."
      @path.pop
      @pointer = @path.reduce(@root) { |dir, d| dir[{:dir, d}] }
    when "/"
      @path = [] of String
      @pointer = @root
    else
      @path << directory
      @pointer[{:dir, directory}] ||= {} of {Symbol, String} => Hash
      @pointer = @pointer[{:dir, directory}]
    end
  end
end

commander = Commander.new
parser = Parser.new(instructions)

while parser.done?
  if parser.next_is_command?
    command = parser.eat
    commander.handle_command(command, parser)
  end
end

pp dirs
