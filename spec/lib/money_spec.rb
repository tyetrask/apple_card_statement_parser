RSpec.describe AppleCardStatementParser::Money do
  let(:currency) { AppleCardStatementParser::Currency::USD }
  let(:amount) { -456710 }
  let(:money) { AppleCardStatementParser::Money.new(amount, currency) }

  describe "::parse" do
    context "when the value is negative" do
      let(:string) { "-$4,123,076.54" }

      it "correctly parses the amount" do
        expect(AppleCardStatementParser::Money.parse(string).amount).to eq(-412307654)
      end

      it "returns an instance of Money" do
        expect(AppleCardStatementParser::Money.parse(string)).to be_a(AppleCardStatementParser::Money)
      end
    end

    context "when the value is positive" do
      let(:string) { "$0.11" }

      it "correctly parses the amount" do
        expect(AppleCardStatementParser::Money.parse(string).amount).to eq(11)
      end

      it "returns an instance of Money" do
        expect(AppleCardStatementParser::Money.parse(string)).to be_a(AppleCardStatementParser::Money)
      end
    end
  end

  describe "#new" do
    it "returns an instance of Money" do
      expect(AppleCardStatementParser::Money.new(nil, nil)).to be_a(AppleCardStatementParser::Money)
    end
  end

  describe "#is_negative?" do
    context "when the amount is negative" do
      let(:amount) { -1456 }

      it "returns true" do
        expect(money.is_negative?).to be(true)
      end
    end

    context "when the amount is zero" do
      let(:amount) { 0 }

      it "returns false" do
        expect(money.is_negative?).to be(false)
      end
    end

    context "when the amount is positive" do
      let(:amount) { 1456 }

      it "returns false" do
        expect(money.is_negative?).to be(false)
      end
    end
  end

  describe "#fractional" do
    let(:amount) { 123 }

    it "returns the fractional amount" do
      expect(money.fractional).to eq(1.23)
    end
  end

  describe "#+" do
    let(:money) { AppleCardStatementParser::Money.parse("$2.00") }
    let(:other_money) { AppleCardStatementParser::Money.parse("$1.00") }

    it "adds the two values" do
      expect((money + other_money).amount).to eq(300)
    end

    it "returns an instance of Money" do
      expect((money + other_money)).to be_a(AppleCardStatementParser::Money)
    end
  end

  describe "#-" do
    let(:money) { AppleCardStatementParser::Money.parse("$5.34") }
    let(:other_money) { AppleCardStatementParser::Money.parse("$2.12") }

    it "adds the two values" do
      expect((money - other_money).amount).to eq(322)
    end

    it "returns an instance of Money" do
      expect((money - other_money)).to be_a(AppleCardStatementParser::Money)
    end
  end

  describe "#to_s" do
    it "formats with negative indicator and currency symbol" do
      expect(money.to_s).to eq("-$4567.10")
    end
  end
end
