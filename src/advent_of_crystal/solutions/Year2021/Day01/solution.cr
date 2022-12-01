class AdventOfCrystal::Solutions::Year2021::Day01::Solution
  def solve(lines : Array(String))
  end
end

solver = AdventOfCrystal::Solutions::Year2021::Day01::Solution.new
input = [] of String
input_file = ARGV[0]

puts "📖 Reading #{input_file}:"

# File.each_line(input_file) do |line|
#   input << line
# end

input = File.read(input_file)
elves = input.split(/\n\n/).map { |inventory| inventory.split(/\n/).map(&.to_i) }.map(&.sum)

p elves.max

# max1 = elves.max
# rem1 = elves.reject { |amount| amount == max1 }
# max2 = rem1.max

# rem2 = rem1.reject { |amount| amount == max2 }
# max3 = rem2.max

# p max1 + max2 + max3

p elves.sort.reverse.first(3).sum
