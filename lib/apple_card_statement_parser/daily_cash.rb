module AppleCardStatementParser
  class DailyCash
    attr_reader :amount, :percentage

    def initialize(amount, percentage)
      @amount = amount
      @percentage = percentage
    end
  end
end
