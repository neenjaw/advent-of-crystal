input_file = ARGV[0]
puts "📖 Reading #{input_file}:"

# File.each_line(input_file) do |line|
#   input << line
# end

module Translate
  def self.to_symbol(whom : Symbol, value : String)
    translation = case whom
                  when :them
                    self.opponent_translation
                  when :self
                    self.self_translation
                  else
                    raise "bad"
                  end
    translation[value]
  end

  def self.opponent_translation
    {
      "A" => :rock,
      "B" => :paper,
      "C" => :scissors,
    }
  end

  def self.self_translation
    {
      "X" => :rock,
      "Y" => :paper,
      "Z" => :scissors,
    }
  end

  def self.to_move
    {
      "X" => :lose,
      "Y" => :draw,
      "Z" => :win,
    }
  end

  def self.play_on_move(them, move)
    case move
    when :win
      case them
      when :rock
        :paper
      when :paper
        :scissors
      when :scissors
        :rock
      end
    when :draw
      them
    when :lose
      case them
      when :rock
        :scissors
      when :paper
        :rock
      when :scissors
        :paper
      end
    end
  end

  def self.points?(play)
    case play
    when :rock
      1
    when :paper
      2
    when :scissors
      3
    else
      0
    end
  end

  def self.win_points?(a, b)
    case [a, b]
    when [:paper, :rock], [:rock, :scissors], [:scissors, :paper]
      6
    when [:paper, :paper], [:rock, :rock], [:scissors, :scissors]
      3
    else
      0
    end
  end
end

input = File.read(input_file)
play = input
  .split(/\n/)
  .reduce(0) do |acc, line|
    them, me = line.split(/\s/)
    them = Translate.to_symbol(:them, them)
    me = Translate.to_symbol(:self, me)

    acc + Translate.points?(me) + Translate.win_points?(me, them)
  end

p play

optimal_play = input
  .split(/\n/)
  .reduce(0) do |acc, line|
    them, me = line.split(/\s/)
    them = Translate.to_symbol(:them, them)
    my_move = Translate.to_move[me]
    my_play = Translate.play_on_move(them, my_move)

    acc + Translate.points?(my_play) + Translate.win_points?(my_play, them)
  end

p optimal_play
