module AppleCardStatementParser
  class ReturnTransaction
    TYPE = "RETURN_TRANSACTION".freeze

    attr_reader :date, :description, :amount, :daily_cash_adjustment

    def initialize(date, description, amount, daily_cash_adjustment)
      @date = date
      @description = description
      @amount = amount
      @daily_cash_adjustment = daily_cash_adjustment
    end

    def id
      "#{@date.strftime("%Y%m%d")}:#{TYPE}:#{@amount.amount}"
    end
  end
end
