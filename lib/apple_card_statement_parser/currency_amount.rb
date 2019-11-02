module AppleCardStatementParser
  class CurrencyAmount
    def initialize(raw_amount)
      @raw_amount = raw_amount
      @pennies = @raw_amount.split("$")[1].gsub(".", "").to_i
    end

    def dollars
      pennies.to_f / 100
    end

    def pennies
      @pennies
    end

    def is_negative?
      @raw_amount.start_with?("-")
    end

    def is_positive?
      !is_negative?
    end
  end
end
