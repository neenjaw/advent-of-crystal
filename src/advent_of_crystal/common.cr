enum ProblemPart
  A = 1
  B = 2

  def self.from_json_object_key?(key) : ProblemPart
    case key
    when "a"
      return ProblemPart::A
    else
      return ProblemPart::B
    end
  end

  def to_json_object_key : String
    self.to_s.downcase
  end
end
