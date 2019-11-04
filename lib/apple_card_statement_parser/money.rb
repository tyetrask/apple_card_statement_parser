module AppleCardStatementParser
  class Money
    PARSE_REGEX = /^(?<negative>-?)(?<currency_symbol>.)(?<amount>(\d|,)*.\d*)$/.freeze

    def self.parse(string)
      match_data = PARSE_REGEX.match(string)
      amount = match_data[:amount].gsub(",", "").gsub(".", "").to_i # Only compatible with USD
      amount = -(amount) if match_data[:negative] == "-"
      currency = Currency.parse(match_data[:currency_symbol])
      new(amount, currency)
    end

    attr_reader :amount, :currency

    def initialize(amount, currency)
      @amount = amount.to_i
      @currency = currency
    end

    def is_negative?
      @amount < 0
    end

    def fractional
      @amount.to_f / 100
    end

    def +(other)
      raise "Cannot add type Money and #{money.class}" unless other.is_a?(Money)
      raise "Cannot add different currency types" if @currency != other.currency
      Money.new(self.amount + other.amount, self.currency)
    end

    def -(other)
      raise "Cannot subtract type Money and #{money.class}" unless other.is_a?(Money)
      raise "Cannot subtract different currency types" if @currency != other.currency
      Money.new(self.amount - other.amount, self.currency)
    end

    def to_s
      "#{is_negative? ? "-" : ""}#{@currency}#{sprintf('%.2f', fractional.abs)}"
    end
  end
end
