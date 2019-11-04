module AppleCardStatementParser
  class Percentage
    PARSE_REGEX = /^(?<negative>-?)(?<amount>\d*)%$/.freeze

    def self.parse(string)
      match_data = PARSE_REGEX.match(string)
      amount = match_data[:amount].to_i
      amount = -amount if match_data[:negative] == "-"
      new(amount)
    end

    def initialize(amount)
      @amount = amount
    end

    def is_negative?
      @amount < 0
    end

    def to_s
      "#{is_negative? ? "-" : ""}#{@amount}%"
    end
  end
end
