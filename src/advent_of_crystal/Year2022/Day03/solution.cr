input_file = ARGV[0]
puts "📖 Reading #{input_file}:"

# File.each_line(input_file) do |line|
#   input << line
# end

input = File.read(input_file)
  .split(/\n/)
  .map do |rucksack|
    size = rucksack.size
    cs = rucksack.chars
    first = cs[0...(size // 2)].to_set
    second = cs[(size // 2)..].to_set
    c = (first & second).to_a.first
    v =
      if 'a' <= c <= 'z'
        c - 'a' + 1
      elsif 'A' <= c <= 'Z'
        c - 'A' + 1 + 26
      else
        c
      end

    v.to_i
  end.sum

pp input

input2 = File.read(input_file)
  .split(/\n/)
  .in_groups_of(3)
  .map do |elves|
    c = elves.compact.map(&.chars.to_set).reduce { |acc, i| acc & i }.to_a.first
    v =
      if 'a' <= c <= 'z'
        c - 'a' + 1
      elsif 'A' <= c <= 'Z'
        c - 'A' + 1 + 26
      else
        c
      end

    v.to_i
  end.sum

pp input2
