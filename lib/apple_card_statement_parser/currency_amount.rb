module AppleCardStatementParser
  class CurrencyAmount
    def initialize(raw_amount: nil, raw_pennies: nil)
      @currency_type = "$" # TODO
      if raw_amount
        @is_negative = raw_amount.start_with?("-")
        @pennies = raw_amount.split("$")[1].gsub(".", "").to_i
      elsif raw_pennies
        @pennies = raw_pennies.abs
        @is_negative = raw_pennies < 0
      end
    end

    def dollars
      pennies.to_f / 100
    end

    def pennies
      is_negative? ? -@pennies : @pennies
    end

    def is_negative?
      @is_negative
    end

    def is_positive?
      !is_negative?
    end

    def to_s
      "#{is_negative? ? "-" : ""}#{@currency_type}#{sprintf('%.2f', dollars.abs)}"
    end
  end
end
