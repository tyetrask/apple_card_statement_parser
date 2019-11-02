module AppleCardStatementParser
  class DailyCashPercentage
    def initialize(value)
      @value = value
    end

    def amount
      @value.gsub("%", "").to_i
    end
  end
end
