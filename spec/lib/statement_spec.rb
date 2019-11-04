RSpec.describe AppleCardStatementParser::Statement do
  let(:filepath) { "/a_folder/Apple Card Statement 3001.pdf" }

  before do
    allow(File).to receive(:exist?).with(filepath).and_return(true)
    allow(File).to receive(:read).and_return("some file contents")
  end

  describe "::read" do
    context "when the file does not exist" do
      before do
        allow(File).to receive(:exist?).with("not_a_real_file.jpg").and_return(false)
      end

      it "raises an error" do
        expect {
          AppleCardStatementParser::Statement.read("not_a_real_file.jpg")
        }.to raise_error(/File does not exist: not_a_real_file.jpg/)
      end
    end

    context "when the file exists" do
      let(:period) { double }
      let(:payments) { double }
      let(:transactions) { double }
      let(:return_transactions) { double }
      let(:data) do
        {
          period: period,
          payments: payments,
          transactions: transactions,
          return_transactions: return_transactions
        }
      end

      before do
        allow(AppleCardStatementParser::Parser).to receive(:perform).with(filepath).and_return(data)
      end

      it "calls Parser::perform with the provided filepath" do
        expect(AppleCardStatementParser::Parser).to receive(:perform).with(filepath).and_return(data)
        AppleCardStatementParser::Statement.read(filepath)
      end

      it "calls #new with the Parser result data" do
        expect(AppleCardStatementParser::Statement).to receive(:new).with(
          filepath,
          period,
          payments,
          transactions,
          return_transactions
        )
        AppleCardStatementParser::Statement.read(filepath)
      end
    end
  end

  describe "#new" do
    context "when the file does not exist" do
      before do
        allow(File).to receive(:exist?).with("not_a_real_file.jpg").and_return(false)
      end

      it "raises an error" do
        expect {
          AppleCardStatementParser::Statement.new("not_a_real_file.jpg", nil, [], [], [])
        }.to raise_error(/File does not exist: not_a_real_file.jpg/)
      end
    end

    context "when the file exists" do
      it "sets @file_hash from the contents of the file" do
        statement = AppleCardStatementParser::Statement.new(filepath, nil, [], [], [])
        expect(statement.file_hash).to eq("7303097b9bf647b7ad202e81547bd7c4")
      end

      it "sets @period from the provided argument" do
        period = double(Range)
        statement = AppleCardStatementParser::Statement.new(filepath, period, [], [], [])
        expect(statement.period).to be(period)
      end

      it "sets @payments from the provided argument" do
        payments = double(Range)
        statement = AppleCardStatementParser::Statement.new(filepath, nil, payments, [], [])
        expect(statement.payments).to be(payments)
      end

      it "sets @transactions from the provided argument" do
        transactions = double(Range)
        statement = AppleCardStatementParser::Statement.new(filepath, nil, [], transactions, [])
        expect(statement.transactions).to be(transactions)
      end

      it "sets @return_transactions from the provided argument" do
        return_transactions = double(Range)
        statement = AppleCardStatementParser::Statement.new(filepath, nil, [], [], return_transactions)
        expect(statement.return_transactions).to be(return_transactions)
      end
    end
  end

  describe "#file_hash" do
    it "returns the computed file hash" do
      statement = AppleCardStatementParser::Statement.new(filepath, nil, [], [], [])
      expect(statement.file_hash).to eq("7303097b9bf647b7ad202e81547bd7c4")
    end
  end

  describe "#period" do
    let(:period) { (Date.today..Date.today) }

    it "returns the statement period" do
      statement = AppleCardStatementParser::Statement.new(filepath, period, [], [], [])
      expect(statement.period).to eq(period)
    end
  end

  describe "#payments" do
    let(:payments) { [AppleCardStatementParser::Payment.new(nil, nil, nil)] }

    it "returns statement payments as an array" do
      statement = AppleCardStatementParser::Statement.new(filepath, nil, payments, [], [])
      expect(statement.payments).to be_a(Array)
      expect(statement.payments).to eq(payments)
    end
  end

  describe "#transactions" do
    let(:transactions) { [AppleCardStatementParser::Transaction.new(nil, nil, nil, nil)] }

    it "returns statement transactions as an array" do
      statement = AppleCardStatementParser::Statement.new(filepath, nil, [], transactions, [])
      expect(statement.transactions).to be_a(Array)
      expect(statement.transactions).to eq(transactions)
    end
  end

  describe "#return_transactions" do
    let(:return_transactions) { [AppleCardStatementParser::ReturnTransaction.new(nil, nil, nil, nil)] }

    it "returns statement payments as an array" do
      statement = AppleCardStatementParser::Statement.new(filepath, nil, [], [], return_transactions)
      expect(statement.return_transactions).to be_a(Array)
      expect(statement.return_transactions).to eq(return_transactions)
    end
  end

  describe "#total_payments" do
    it "returns the sum of all payments as a Money object" do
      payments = [
        AppleCardStatementParser::Payment.new(nil, nil, AppleCardStatementParser::Money.parse("-$47.01")),
        AppleCardStatementParser::Payment.new(nil, nil, AppleCardStatementParser::Money.parse("-$12.03")),
        AppleCardStatementParser::Payment.new(nil, nil, AppleCardStatementParser::Money.parse("-$100.00"))
      ]
      statement = AppleCardStatementParser::Statement.new(filepath, nil, payments, [], [])
      expect(statement.total_payments).to be_a(AppleCardStatementParser::Money)
      expect(statement.total_payments.amount).to eq(-15904)
    end
  end

  describe "#total_charges_credits_and_returns" do
    it "returns the sum of all transactions and return transactions as a Money object" do
      transactions = [
        AppleCardStatementParser::Transaction.new(nil, nil, nil, AppleCardStatementParser::Money.parse("$52.08")),
        AppleCardStatementParser::Transaction.new(nil, nil, nil, AppleCardStatementParser::Money.parse("$1,001.03"))
      ]
      return_transactions = [
        AppleCardStatementParser::ReturnTransaction.new(nil, nil, AppleCardStatementParser::Money.parse("-$1,001.03"), nil),
      ]
      statement = AppleCardStatementParser::Statement.new(filepath, nil, [], transactions, return_transactions)
      expect(statement.total_charges_credits_and_returns).to be_a(AppleCardStatementParser::Money)
      expect(statement.total_charges_credits_and_returns.amount).to eq(5208)
    end
  end

  describe "#total_daily_cash_earned" do
    it "returns the sum of all daily cash and daily cash adjustments as a Money object" do
      transaction_one_daily_cash = AppleCardStatementParser::DailyCash.new(
        AppleCardStatementParser::Money.parse("$1.15"),
        AppleCardStatementParser::Percentage.parse("2%")
      )
      transaction_two_daily_cash = AppleCardStatementParser::DailyCash.new(
        AppleCardStatementParser::Money.parse("$0.02"),
        AppleCardStatementParser::Percentage.parse("1%")
      )
      return_one_daily_cash_adjustment = AppleCardStatementParser::DailyCash.new(
        AppleCardStatementParser::Money.parse("$0.02"),
        AppleCardStatementParser::Percentage.parse("-1%")
      )
      transactions = [
        AppleCardStatementParser::Transaction.new(nil, nil, transaction_one_daily_cash, nil),
        AppleCardStatementParser::Transaction.new(nil, nil, transaction_two_daily_cash, nil)
      ]
      return_transactions = [
        AppleCardStatementParser::ReturnTransaction.new(nil, nil, nil, return_one_daily_cash_adjustment),
      ]
      statement = AppleCardStatementParser::Statement.new(filepath, nil, [], transactions, return_transactions)
      expect(statement.total_daily_cash_earned).to be_a(AppleCardStatementParser::Money)
      expect(statement.total_daily_cash_earned.amount).to eq(115)
    end
  end
end
