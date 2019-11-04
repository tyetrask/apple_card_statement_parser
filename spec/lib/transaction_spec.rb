RSpec.describe AppleCardStatementParser::Transaction do
  describe "#new" do
    it "returns an instance of Transaction" do
      expect(AppleCardStatementParser::Transaction.new(nil, nil, nil, nil))
        .to be_a(AppleCardStatementParser::Transaction)
    end
  end

  describe "#id" do
    let(:date) { Date.new(2022, 03, 04) }
    let(:amount) { AppleCardStatementParser::Money.parse("$5.67") }

    it "returns an identifier to help uniquely identify the transaction" do
      payment = AppleCardStatementParser::Transaction.new(date, "", nil, amount)
      expect(payment.id).to eq("20220304:TRANSACTION:567")
    end
  end
end
