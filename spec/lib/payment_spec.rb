RSpec.describe AppleCardStatementParser::Payment do
  describe "#new" do
    it "returns an instance of Payment" do
      expect(AppleCardStatementParser::Payment.new(nil, nil, nil))
        .to be_a(AppleCardStatementParser::Payment)
    end
  end

  describe "#id" do
    let(:date) { Date.new(2021, 02, 03) }
    let(:amount) { AppleCardStatementParser::Money.parse("$4.56") }

    it "returns an identifier to help uniquely identify the payment" do
      payment = AppleCardStatementParser::Payment.new(date, "", amount)
      expect(payment.id).to eq("20210203:PAYMENT:456")
    end
  end
end
