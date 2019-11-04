RSpec.describe AppleCardStatementParser::ReturnTransaction do
  describe "#new" do
    it "returns an instance of Payment" do
      expect(AppleCardStatementParser::ReturnTransaction.new(nil, nil, nil, nil))
        .to be_a(AppleCardStatementParser::ReturnTransaction)
    end
  end

  describe "#id" do
    let(:date) { Date.new(2023, 04, 05) }
    let(:amount) { AppleCardStatementParser::Money.parse("$6.78") }

    it "returns an identifier to help uniquely identify the return transaction" do
      payment = AppleCardStatementParser::ReturnTransaction.new(date, "", amount, nil)
      expect(payment.id).to eq("20230405:RETURN_TRANSACTION:678")
    end
  end
end
