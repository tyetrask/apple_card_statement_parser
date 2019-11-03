module AppleCardStatementParser
  class ReturnTransaction
    include FormatValidators

    def initialize(raw_date, raw_description, raw_return_amount, raw_indicator_string, raw_daily_cash_percentage_adjustment, raw_daily_cash_amount_adjustment)
      @raw_date = raw_date
      @raw_description = raw_description
      @raw_return_amount = raw_return_amount
      @raw_indicator_string = raw_indicator_string
      @raw_daily_cash_percentage_adjustment = raw_daily_cash_percentage_adjustment
      @raw_daily_cash_amount_adjustment = raw_daily_cash_amount_adjustment
    end

    def date
      as_date(@raw_date)
    end

    def description
      @raw_description
    end

    def amount
      as_amount(@raw_return_amount)
    end

    def daily_cash_adjustment
      DailyCash.new(@raw_daily_cash_amount_adjustment, @raw_daily_cash_percentage_adjustment)
    end

    def is_valid?
      is_a_date?(@raw_date) &&
        is_a_description?(@raw_description) &&
        @raw_description.include?(RETURN_STRING_MATCH) &&
        is_an_amount?(@raw_return_amount) &&
        @raw_indicator_string == DAILY_CASH_ADJUSTMENT_INDICATOR_STRING &&
        is_a_percent?(@raw_daily_cash_percentage_adjustment) &&
        is_an_amount?(@raw_daily_cash_amount_adjustment)
    end
  end
end
