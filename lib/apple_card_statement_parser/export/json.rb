require "date"
require "json"

module AppleCardStatementParser
  module Export
    class JSON
      def initialize(statement)
        @statement = statement
      end

      def as_json
        data = {transactions: []}
        @statement.payments.each do |payment|
          data[:transactions] << {
            id: payment.id,
            date: payment.date,
            type: Payment::TYPE,
            amount: payment.amount,
            description: payment.description
          }
        end
        @statement.transactions.each do |transaction|
          data[:transactions] << {
            id: transaction.id,
            date: transaction.date,
            type: Transaction::TYPE,
            amount: transaction.amount,
            description: transaction.description
          }
        end
        @statement.return_transactions.each do |return_transaction|
          data[:transactions] << {
            id: return_transaction.id,
            date: return_transaction.date,
            type: ReturnTransaction::TYPE,
            amount: return_transaction.amount,
            description: return_transaction.description
          }
        end
        data
      end

      def write(filepath)
        File.open(filepath, "w") { |f| f.write(::JSON.generate(as_json)) }
      end
    end
  end
end
