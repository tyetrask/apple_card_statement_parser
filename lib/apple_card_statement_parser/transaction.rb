module AppleCardStatementParser
  class Transaction
    include FormatValidators

    def initialize(raw_date, raw_description, raw_daily_cash_percentage, raw_daily_cash_amount, raw_amount)
      @raw_date = raw_date
      @raw_description = raw_description
      @raw_daily_cash_percentage = raw_daily_cash_percentage
      @raw_daily_cash_amount = raw_daily_cash_amount
      @raw_amount = raw_amount
    end

    def date
      as_date(@raw_date)
    end

    def description
      @raw_description
    end

    def daily_cash
      DailyCash.new(@raw_daily_cash_amount, @raw_daily_cash_percentage)
    end

    def amount
      as_amount(@raw_amount)
    end

    def is_valid?
      is_a_date?(@raw_date) &&
        is_a_description?(@raw_description) &&
        !@raw_description.include?(RETURN_STRING_MATCH) &&
        is_a_percent?(@raw_daily_cash_percentage) &&
        is_an_amount?(@raw_daily_cash_amount) &&
        is_an_amount?(@raw_amount)
    end
  end
end
