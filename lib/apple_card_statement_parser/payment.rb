module AppleCardStatementParser
  class Payment
    TYPE = "PAYMENT".freeze

    attr_reader :date, :description, :amount

    def initialize(date, description, amount)
      @date = date
      @description = description
      @amount = amount
    end

    def id
      "#{@date.strftime("%Y%m%d")}:#{TYPE}:#{@amount.amount}"
    end
  end
end
