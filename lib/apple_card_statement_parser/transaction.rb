module AppleCardStatementParser
  class Transaction
    TYPE = "TRANSACTION".freeze

    attr_reader :date, :description, :daily_cash, :amount

    def initialize(date, description, daily_cash, amount)
      @date = date
      @description = description
      @daily_cash = daily_cash
      @amount = amount
    end

    def id
      "#{@date.strftime("%Y%m%d")}:#{TYPE}:#{@amount.amount}"
    end
  end
end
