input_file = ARGV[0]
puts "📖 Reading #{input_file}:"

# File.each_line(input_file) do |line|
#   input << line
# end

module T
  def self.to_set(notation : String)
    beginning, ending = notation.split(/-/).map(&.to_i)
    Range.new(beginning, ending).to_set
  end
end

input = File.read(input_file)
  .split(/\n/)
  .map do |line|
    a, b = line.split(/,/)
    aset = T.to_set(a)
    bset = T.to_set(b)

    if (aset.superset_of? bset) || (bset.superset_of? aset)
      1
    else
      0
    end
  end.sum

pp input

input2 = File.read(input_file)
  .split(/\n/)
  .map do |line|
    a, b = line.split(/,/)
    aset = T.to_set(a)
    bset = T.to_set(b)

    if (aset & bset).size != 0
      1
    else
      0
    end
  end.sum

pp input2
