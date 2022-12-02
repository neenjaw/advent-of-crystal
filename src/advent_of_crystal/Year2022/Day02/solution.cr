input_file = ARGV[0]

puts "📖 Reading #{input_file}:"

# File.each_line(input_file) do |line|
#   input << line
# end

input = File.read(input_file)
elves = input.split(/\n\n/)
  .map { |inventory| inventory.split(/\n/).map(&.to_i).sum }

p elves.max

p elves.sort.reverse.first(3).sum
