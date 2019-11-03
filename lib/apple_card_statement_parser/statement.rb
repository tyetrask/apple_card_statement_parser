require "pdf-reader"
require "json"
require "digest/md5"
require "date"
require "csv"

module AppleCardStatementParser
  class Statement
    THREE_OR_MORE_SPACE_REGEX = /\s{3,}/.freeze
    PERIOD_REGEX = /(?<start_month>\w\w\w) (?<start_day>\d{1,}) . (?<end_month>\w\w\w) (?<end_day>\d{1,}), (?<year>\d\d\d\d)/.freeze
    PERIOD_FORMAT = "%b %d %Y".freeze
    VERSION_AUTODETECT = "AUTODETECT".freeze
    VERSION_1 = "1".freeze
    VALID_VERSIONS = [VERSION_1].freeze

    attr_reader :file_hash,
                :filename,
                :payments,
                :period,
                :transactions,
                :return_transactions

    def initialize(pdf_filepath, statement_version = VERSION_AUTODETECT)
      @pdf_filepath = pdf_filepath
      @statement_version = VERSION_1
      if !VALID_VERSIONS.include?(@statement_version)
        raise "Invalid statement version: #{@statement_version}"
      end
      raise "File does not exist! #{@pdf_filepath}" unless File.exist?(@pdf_filepath)
      @filename = File.basename(@pdf_filepath, ".*")
      @file_hash = Digest::MD5.hexdigest(File.read(@pdf_filepath))
    end

    def read!
      @payments = []
      @transactions = []
      @return_transactions = []

      lines = PDF::Reader.new(@pdf_filepath)
        .pages
        .collect { |page| page.text.split(NEWLINE_CHARACTER) }
        .flatten
        .select { |line| line.is_a?(String) && line.length > 0 }

      lines.each.with_index do |line, index|
        if @period.nil?
          period = as_period(line)
          if !period.nil?
            @period = period
            next
          end
        end

        payment = as_payment(line)
        if payment.is_valid?
          @payments << payment
          next
        end

        transaction = as_transaction(line)
        if transaction.is_valid?
          @transactions << transaction
          next
        end

        return_transaction = as_return_transaction(line, lines[index + 1])
        if return_transaction.is_valid?
          @return_transactions << return_transaction
          next
        end
      end
      self
    end

    def total_payments
      payments_amount = @payments.collect { |payment| payment.amount.pennies }.sum
      CurrencyAmount.new(raw_pennies: payments_amount)
    end

    def total_charges_credits_and_returns
      transactions_amount = @transactions
        .collect { |transaction| transaction.amount.pennies }
        .sum
      return_transactions_amount = @return_transactions
        .collect { |return_transaction| return_transaction.amount.pennies }
        .sum
      total_amount = transactions_amount + return_transactions_amount
      CurrencyAmount.new(raw_pennies: total_amount)
    end

    def total_daily_cash_earned
      daily_cash_earned = @transactions
        .collect { |transaction| transaction.daily_cash.amount.pennies }
        .sum
      daily_cash_adjusted = @return_transactions
        .collect { |return_transaction| return_transaction.daily_cash_adjustment.amount.pennies }
        .sum
      daily_cash_amount = daily_cash_earned - daily_cash_adjusted
      CurrencyAmount.new(raw_pennies: daily_cash_amount)
    end

    def as_json
      {} # TODO
    end

    def as_csv
      [] # TODO
    end

    def write_json!(filepath)
      File.open(filepath, "w") { |f| f.write(JSON.generate(as_json)) }
    end

    def write_csv!(filepath)
      CSV.open(filepath, "wb") { |csv| as_csv.each { |row| csv << row } }
    end

    private

    def as_period(line)
      parsed_line = line.strip.split(THREE_OR_MORE_SPACE_REGEX)
      name_and_email, period = parsed_line
      return nil unless name_and_email.include?(",") && name_and_email.include?("@")
      period_match_data = PERIOD_REGEX.match(period)
      start_month = period_match_data[:start_month]
      start_day = period_match_data[:start_day]
      end_month = period_match_data[:end_month]
      end_day = period_match_data[:end_day]
      year = period_match_data[:year]

      start_date = Date.strptime("#{start_month} #{start_day} #{year}", PERIOD_FORMAT)
      end_date = Date.strptime("#{end_month} #{end_day} #{year}", PERIOD_FORMAT)
      (start_date..end_date)
    rescue => error
      nil
    end

    def as_payment(line)
      parsed_line = line.strip.split(THREE_OR_MORE_SPACE_REGEX)
      date, description, amount = parsed_line
      Payment.new(date, description, amount)
    end

    def as_transaction(line)
      parsed_line = line.strip.split(THREE_OR_MORE_SPACE_REGEX)
      date, description, daily_cash_percentage, daily_cash_value, amount = parsed_line
      Transaction.new(date, description, daily_cash_percentage, daily_cash_value, amount)
    end

    def as_return_transaction(line, next_line)
      parsed_line = line.strip.split(THREE_OR_MORE_SPACE_REGEX)
      date, description, return_amount = parsed_line
      parsed_next_line = next_line.to_s.strip.split(THREE_OR_MORE_SPACE_REGEX)
      indicator, daily_cash_percentage_adjustment, daily_cash_amount_adjustment = parsed_next_line
      ReturnTransaction.new(
        date,
        description,
        return_amount,
        indicator,
        daily_cash_percentage_adjustment,
        daily_cash_amount_adjustment
      )
    end
  end
end
