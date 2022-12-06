input_file = ARGV[0]
puts "📖 Reading #{input_file}:"

# File.each_line(input_file) do |line|
#   input << line
# end
found = -1
cs = File.read(input_file).chomp.chars
cs.each_with_index do |_, i|
  if i < 3 || found != -1
    next
  end

  s = Set.new([cs[i], cs[i - 1], cs[i - 2], cs[i - 3]])
  if found == -1 && s.size == 4
    found = i
    break
  end
end
pp found + 1

found2 = -1
cs.each_with_index do |_, i|
  if i < 13 || found2 != -1
    next
  end

  s = Set.new(cs[(i - 13)..i])
  if found2 == -1 && s.size == 14
    found2 = i
    break
  end
end
pp found2 + 1
