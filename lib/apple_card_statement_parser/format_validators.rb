require "date"

module AppleCardStatementParser
  module FormatValidators
    DATE_FORMAT = "%m/%d/%Y".freeze
    VALID_PERCENTAGES = ["1%", "2%", "3%", "-1%", "-2%", "-3%"].freeze

    private

    def as_date(value)
      Date.strptime(value, DATE_FORMAT)
    end

    def is_a_date?(value)
      as_date(value)
      true
    rescue TypeError, ArgumentError
      false
    end

    def is_a_description?(value)
      value.is_a?(String) && value.length > 0
    end

    def as_percentage(value)
      DailyCashPercentage.new(value)
    end

    def is_a_percent?(value)
      VALID_PERCENTAGES.include?(value)
    end

    def as_amount(value)
      CurrencyAmount.new(raw_amount: value)
    end

    def is_an_amount?(value)
      value.is_a?(String) &&
        value.include?(CURRENCY_CHARACTER) &&
        value.include?(PERIOD_CHARACTER)
    end
  end
end
