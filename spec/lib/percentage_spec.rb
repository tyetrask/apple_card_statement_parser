RSpec.describe AppleCardStatementParser::Percentage do
  let(:amount) { 3 }
  let(:percentage) { AppleCardStatementParser::Percentage.new(amount) }

  describe "::parse" do
    context "when the value is negative" do
      let(:string) { "-3%" }

      it "correctly parses the amount" do
        expect(AppleCardStatementParser::Percentage.parse(string).amount).to eq(-3)
      end

      it "returns an instance of Percentage" do
        expect(AppleCardStatementParser::Percentage.parse(string)).to be_a(AppleCardStatementParser::Percentage)
      end
    end

    context "when the value is positive" do
      let(:string) { "2%" }

      it "correctly parses the amount" do
        expect(AppleCardStatementParser::Percentage.parse(string).amount).to eq(2)
      end

      it "returns an instance of Percentage" do
        expect(AppleCardStatementParser::Percentage.parse(string)).to be_a(AppleCardStatementParser::Percentage)
      end
    end
  end

  describe "#new" do
    it "returns an instance of Percentage" do
      expect(AppleCardStatementParser::Percentage.new("2")).to be_a(AppleCardStatementParser::Percentage)
    end
  end

  describe "#is_negative?" do
    context "when the amount is negative" do
      let(:amount) { -2 }

      it "returns true" do
        expect(percentage.is_negative?).to be(true)
      end
    end

    context "when the amount is zero" do
      let(:amount) { 0 }

      it "returns false" do
        expect(percentage.is_negative?).to be(false)
      end
    end

    context "when the amount is positive" do
      let(:amount) { 3 }

      it "returns false" do
        expect(percentage.is_negative?).to be(false)
      end
    end
  end

  describe "#to_s" do
    let(:amount) { -1 }

    it "formats with negative indicator and currency symbol" do
      expect(percentage.to_s).to eq("-1%")
    end
  end
end
