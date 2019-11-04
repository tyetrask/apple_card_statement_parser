require "csv"
require "date"

module AppleCardStatementParser
  module Export
    class CSV
      HEADER = [:date, :type, :amount, :description, :id]

      def initialize(statement)
        @statement = statement
      end

      def write(filepath)
        ::CSV.open(filepath, "wb") { |csv| as_csv.each { |row| csv << row } }
      end

      private

      def as_csv
        data = [HEADER]
        @statement.payments.each do |payment|
          data << [payment.date, Payment::TYPE, payment.amount, payment.description, payment.id]
        end
        @statement.transactions.each do |transaction|
          data << [transaction.date, Transaction::TYPE, transaction.amount, transaction.description, transaction.id]
        end
        @statement.return_transactions.each do |return_transaction|
          data << [return_transaction.date, ReturnTransaction::TYPE, return_transaction.amount, return_transaction.description, return_transaction.id]
        end
        data
      end

    end
  end
end
