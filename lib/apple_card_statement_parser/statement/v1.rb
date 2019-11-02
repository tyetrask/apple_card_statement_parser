require "pdf-reader"
require "json"

module AppleCardStatementParser
  class Statement
    class V1
      THREE_OR_MORE_SPACE_REGEX = /\s{3,}/.freeze

      attr_reader :period, :payments, :transactions

      def initialize(pdf_filepath)
        @pdf_filepath = pdf_filepath
        raise "File does not exist! #{@pdf_filepath}" unless File.exist?(@pdf_filepath)
        @filename = File.basename(@pdf_filepath, ".*")
      end

      def read!
        @payments = []
        @transactions = []

        PDF::Reader.new(@pdf_filepath)
          .pages
          .collect { |page| page.text.split(NEWLINE_CHARACTER) }
          .flatten
          .select { |line| line != EMPTY_STRING }
          .compact
          .each do |line|
            payment = as_payment(line)
            if payment.is_valid?
              @payments << payment
              next
            end

            transaction = as_transaction(line)
            if transaction.is_valid?
              @transactions << transaction
            end
          end
        true
      end

      def as_json
        {

        }
      end

      def write_json!(filepath)
        File.open(filepath, 'w') {|f| f.write(JSON.generate(as_json)) }
      end

      private

      def as_payment(line)
        parsed = line.strip.split(THREE_OR_MORE_SPACE_REGEX)
        date, description, amount = parsed
        Payment.new(date, description, amount)
      end

      def as_transaction(line)
        parsed = line.strip.split(THREE_OR_MORE_SPACE_REGEX)
        date, description, daily_cash_percentage, daily_cash_value, amount = parsed
        Transaction.new(date, description, daily_cash_percentage, daily_cash_value, amount)
      end
    end
  end
end
