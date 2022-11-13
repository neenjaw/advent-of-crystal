require "xml"

require "../exception/rate_limit_exception"

class Client
  class SubmitResponse
    getter correct : Bool
    getter message : String

    def initialize(
      @correct : Bool,
      @message : String
    )
    end

    def self.parse_from_html(html : IO) : self
      document = XML.parse_html(html)

      rate_limit_node = document.xpath_node("//*[text()[contains(.,\"You gave an answer too recently\")]]")
      raise RateLimitException.new(rate_limit_node.text) if rate_limit_node

      correct_node = document.xpath_node("//*[text()[contains(.,\"That's the right answer\")]]")
      incorrect_node = document.xpath_node("//*[text()[contains(.,\"That's not the right answer\")]]")
      node = correct_node || incorrect_node

      self.new(!!correct_node, node.try &.text || "")
    end
  end
end
