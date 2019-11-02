module AppleCardStatementParser
  class DailyCash
    include FormatValidators

    def initialize(raw_amount, raw_percentage)
      @raw_amount = raw_amount
      @raw_percentage = raw_percentage
    end

    def percentage
      DailyCashPercentage.new(@raw_percentage)
    end

    def amount
      as_amount(@raw_amount)
    end
  end
end
