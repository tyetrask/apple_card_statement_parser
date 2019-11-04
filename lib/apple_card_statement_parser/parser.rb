module AppleCardStatementParser
  class Parser
    NEWLINE_CHARACTER = "\n".freeze

    THREE_OR_MORE_SPACE_REGEX = /\s{3,}/.freeze
    MM_DD_YYYY_REGEX = /(?<month>\d\d)\/(?<day>\d\d)\/(?<year>\d\d\d\d)/.freeze
    DESCRIPTION_REGEX = /(?<description>(?:(?!#{THREE_OR_MORE_SPACE_REGEX}).)*?)/.freeze
    RETURN_DESCRIPTION_REGEX = /(?<description>(?:(?!#{THREE_OR_MORE_SPACE_REGEX}).)*?) \(RETURN\)/.freeze
    DAILY_CASH_PERCENTAGE_REGEX = /(?<daily_cash_percentage>-?\d*%)/.freeze
    DAILY_CASH_AMOUNT_REGEX = /(?<daily_cash_amount>-?\$(\d|,)*.\d*)/.freeze
    AMOUNT_REGEX = /(?<amount>(-\$|\$)(\d|,)*.\d*)/.freeze

    PERIOD_REGEX = /^\s*(?<name>.*), (?<email>.*)#{THREE_OR_MORE_SPACE_REGEX}(?<start_month_name_short>\w\w\w) (?<start_day>\d{1,}) . (?<end_month_name_short>\w\w\w) (?<end_day>\d{1,}), (?<year>\d\d\d\d)\s*$/.freeze
    PAYMENT_REGEX = /^\s*#{MM_DD_YYYY_REGEX}\s*#{DESCRIPTION_REGEX}#{THREE_OR_MORE_SPACE_REGEX}#{AMOUNT_REGEX}\s*$/.freeze
    TRANSACTION_REGEX = /^\s*#{MM_DD_YYYY_REGEX}\s*#{DESCRIPTION_REGEX}#{THREE_OR_MORE_SPACE_REGEX}#{DAILY_CASH_PERCENTAGE_REGEX}#{THREE_OR_MORE_SPACE_REGEX}#{DAILY_CASH_AMOUNT_REGEX}#{THREE_OR_MORE_SPACE_REGEX}#{AMOUNT_REGEX}\s*$/.freeze
    RETURN_TRANSACTION_REGEX = /^\s*#{MM_DD_YYYY_REGEX}\s*#{RETURN_DESCRIPTION_REGEX}#{THREE_OR_MORE_SPACE_REGEX}#{AMOUNT_REGEX}\s*$/.freeze
    DAILY_CASH_ADJUSTMENT_REGEX = /^\s*Daily Cash Adjustment#{THREE_OR_MORE_SPACE_REGEX}#{DAILY_CASH_PERCENTAGE_REGEX}#{THREE_OR_MORE_SPACE_REGEX}#{AMOUNT_REGEX}\s*$/.freeze

    class << self
      def perform(filepath)
        data = {period: nil, payments: [], transactions: [], return_transactions: []}

        lines = PDF::Reader.new(filepath)
          .pages
          .collect { |page| page.text.split(NEWLINE_CHARACTER) }
          .flatten
          .select { |line| line.is_a?(String) && line.length > 0 }

        lines.each.with_index do |line, index|
          if data[:period].nil?
            if line.match?(PERIOD_REGEX)
              data[:period] = as_period(line)
              next
            end
          end

          next_line = lines[index + 1].to_s
          if line.match?(RETURN_TRANSACTION_REGEX) && next_line.match?(DAILY_CASH_ADJUSTMENT_REGEX)
            data[:return_transactions] << as_return_transaction(line, next_line)
            next
          end

          if line.match?(TRANSACTION_REGEX)
            data[:transactions] << as_transaction(line)
            next
          end

          if line.match?(PAYMENT_REGEX)
            data[:payments] << as_payment(line)
            next
          end
        end
        data
      end

      private

      def as_period(line)
        match_data = PERIOD_REGEX.match(line)
        start_month = Date::ABBR_MONTHNAMES.index(match_data[:start_month_name_short])
        end_month = Date::ABBR_MONTHNAMES.index(match_data[:end_month_name_short])
        start_date = Date.new(match_data[:year].to_i, start_month, match_data[:start_day].to_i)
        end_date = Date.new(match_data[:year].to_i, end_month, match_data[:end_day].to_i)
        (start_date..end_date)
      rescue => error
        nil
      end

      def as_payment(line)
        match_data = PAYMENT_REGEX.match(line)
        date = Date.new(match_data[:year].to_i, match_data[:month].to_i, match_data[:day].to_i)
        description = match_data[:description]
        amount = Money.parse(match_data[:amount])
        Payment.new(date, description, amount)
      end

      def as_transaction(line)
        match_data = TRANSACTION_REGEX.match(line)
        date = Date.new(match_data[:year].to_i, match_data[:month].to_i, match_data[:day].to_i)
        description = match_data[:description]
        daily_cash_percentage = Percentage.parse(match_data[:daily_cash_percentage])
        daily_cash_amount = Money.parse(match_data[:daily_cash_amount])
        daily_cash = DailyCash.new(daily_cash_amount, daily_cash_percentage)
        amount = Money.parse(match_data[:amount])
        Transaction.new(date, description, daily_cash, amount)
      end

      def as_return_transaction(line, next_line)
        match_data = RETURN_TRANSACTION_REGEX.match(line)
        next_match_data = DAILY_CASH_ADJUSTMENT_REGEX.match(next_line)
        date = Date.new(match_data[:year].to_i, match_data[:month].to_i, match_data[:day].to_i)
        description = match_data[:description]
        amount = Money.parse(match_data[:amount])
        daily_cash_adjustment_percentage = Percentage.parse(next_match_data[:daily_cash_percentage])
        daily_cash_adjustment_amount = Money.parse(next_match_data[:amount])
        daily_cash_adjustment = DailyCash.new(daily_cash_adjustment_amount, daily_cash_adjustment_percentage)
        ReturnTransaction.new(
          date,
          description,
          amount,
          daily_cash_adjustment
        )
      end
    end
  end
end
