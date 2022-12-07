class Parser
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
    peek.start_with?("$")
  end
end

class Commander
  def initialize(content)
    @root = {}
    @path = []
    @pointer = @root

    parse(content)
  end

  def parse(content)
    parser = Parser.new(content)

    while !parser.done?
      if parser.next_is_command?
        command = parser.eat
        handle_command(command, parser)
      end
    end
  end

  def handle_command(command, parser)
    if command.match(/\$ cd ([\/\w.]+)/)
      change_directory($~[1])
    elsif command.match(/\$ ls/)
      list_directory(parser)
    end
  end

  def list_directory(parser)
    return if parser.done? || parser.next_is_command?

    a, b = parser.eat.strip.split(/ /)
    case a
    when "dir"
      @pointer[[:dir, b]] ||= {}
    else
      @pointer[[:file, b]] ||= a.to_i
    end

    list_directory(parser)
  end

  def change_directory(directory)
    case directory
    when ".."
      @path.pop
      @pointer = @path.reduce(@root) { |dir, d| dir[[:dir, d]] }
    when "/"
      @path = []
      @pointer = @root
    else
      @path << directory
      @pointer[[:dir, directory]] ||= {}
      @pointer = @pointer[[:dir, directory]]
    end
  end

  def du
    histogram = {}
    do_du(@root, histogram, ["/"])
    histogram
  end

  def do_du(node, histogram, breadcrumb)
    sum = node.keys.reduce(0) do |acc, (type, name)|
      if type == :dir
        acc += do_du(node[[type, name]], histogram, [*breadcrumb, name])
      else
        acc += node[[type, name]]
      end
    end

    histogram[breadcrumb] = sum
  end
end

content = ARGF.read.chomp.split(/\n/)

# lines = ARGF.readlines.chomp

commander = Commander.new(content)

# pp commander

pp commander.du #.filter {|_, size| size <= 100000}.sum { |_, size| size}
pp commander.du.filter {|_, size| size <= 100000}.sum { |_, size| size}
pp commander.du.filter {|_, size| (30_000_000 - (70_000_000 - 48_008_081)) <= size}.map {|_, v| v}.min