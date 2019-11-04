require "date"
require "digest/md5"
require "pdf-reader"

module AppleCardStatementParser
  class Statement
    VERSION_AUTODETECT = "AUTODETECT".freeze
    VERSION_1 = "1".freeze
    VALID_VERSIONS = [VERSION_1].freeze

    attr_reader :file_hash, :period, :payments, :transactions, :return_transactions

    def self.read(filepath, statement_version = VERSION_AUTODETECT)
      raise "File does not exist: #{filepath}" unless File.exist?(filepath)
      data = Parser.perform(filepath)
      new(
        filepath,
        data[:period],
        data[:payments],
        data[:transactions],
        data[:return_transactions]
      )
    end

    def initialize(filepath, period, payments, transactions, return_transactions)
      @filepath = filepath
      raise "File does not exist: #{@filepath}" unless File.exist?(@filepath)
      @file_hash = Digest::MD5.hexdigest(File.read(@filepath))
      @period = period
      @payments = payments
      @transactions = transactions
      @return_transactions = return_transactions
      @statement_version = VERSION_1
    end

    def total_payments
      @payments.collect { |payment| payment.amount }.reduce(:+)
    end

    def total_charges_credits_and_returns
      @transactions.collect { |t| t.amount }.reduce(:+) +
        @return_transactions.collect { |rt| rt.amount }.reduce(:+)
    end

    def total_daily_cash_earned
      @transactions.collect { |t| t.daily_cash.amount }.reduce(:+) -
        @return_transactions.collect { |rt| rt.daily_cash_adjustment.amount }.reduce(:+)
    end
  end
end
