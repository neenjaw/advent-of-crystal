input_file = ARGV[0]
puts "📖 Reading #{input_file}:"

# File.each_line(input_file) do |line|
#   input << line
# end

puzzle_in, moves_in = File.read(input_file).chomp.split(/\n\n/).map(&.split(/\n/))

class Puzzle
  def initialize(input)
    @stacks = {} of Int32 => Array(Char)

    input.reverse[1..].each do |line|
      line.chars.in_groups_of(4).each_with_index do |group, i|
        _, c = group
        unshift_stack(i + 1, c) unless !c || c == ' '
      end
    end
  end

  def unshift_stack(col : Int32, value : Char)
    @stacks[col] ||= [] of Char
    @stacks[col].unshift(value)
  end

  def move(from : Int32, to : Int32, count : Int32)
    count.times { do_move(from, to) }
  end

  private def do_move(from, to)
    value = @stacks[from].shift
    unshift_stack(to, value)
  end

  def move_many(from : Int32, to : Int32, count : Int32)
    values = @stacks[from].shift(count)
    @stacks[to] ||= [] of Char
    @stacks[to] = values + @stacks[to]
  end

  def get_tops
    @stacks.keys.sort.map { |k| @stacks[k][0] }.compact.join
  end
end

part1 = moves_in.reduce(Puzzle.new(puzzle_in)) do |puzzle, move|
  move.match(/^move (\d+) from (\d+) to (\d+)$/)
  puzzle.move($~[2].to_i, $~[3].to_i, $~[1].to_i)
  puzzle
end.get_tops

pp part1

part2 = moves_in.reduce(Puzzle.new(puzzle_in)) do |puzzle, move|
  move.match(/^move (\d+) from (\d+) to (\d+)$/)
  puzzle.move_many($~[2].to_i, $~[3].to_i, $~[1].to_i)
  puzzle
end.get_tops

pp part2
