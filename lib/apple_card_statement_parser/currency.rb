module AppleCardStatementParser
  class Currency
    include Comparable

    attr_reader :type, :symbol

    def self.parse(value)
      CURRENCIES.each do |currency|
        return currency if currency.type == value || currency.symbol == value
      end
      raise "Could not find currency for: #{value}"
    end

    def initialize(type, symbol)
      @type = type
      @symbol = symbol
    end

    def to_s
      @symbol
    end

    def <=>(other)
      @type <=> other.type
    end

    USD = self.new("USD", "$")
    CURRENCIES = [USD].freeze
  end
end
