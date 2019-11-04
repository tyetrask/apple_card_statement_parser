RSpec.describe AppleCardStatementParser::Currency do

  describe "::parse" do
    context "when a supported currency type is provided" do
      it "returns the matching Currency instance" do
        expect(AppleCardStatementParser::Currency.parse("USD")).to eq(AppleCardStatementParser::Currency::USD)
      end
    end

    context "when a supposed currency symbol is provided" do
      it "returns the matching Currency instance" do
        expect(AppleCardStatementParser::Currency.parse("$")).to eq(AppleCardStatementParser::Currency::USD)
      end
    end
  end

  describe "#new" do
    it "returns an instance of Currency" do
      expect(AppleCardStatementParser::Currency.new("USD", "$")).to be_a(AppleCardStatementParser::Currency)
    end
  end

  describe "#to_s" do
    it "returns the currency symbol" do
      expect(AppleCardStatementParser::Currency::USD.to_s).to eq("$")
    end
  end

  describe "#<=>" do
    let(:eur) { AppleCardStatementParser::Currency.new("EUR", "€") }
    let(:usd) { AppleCardStatementParser::Currency.new("USD", "$") }

    context "when the Currency types are equal" do
      it "returns true" do
        expect(usd == AppleCardStatementParser::Currency::USD).to be(true)
      end
    end

    context "when the Currency types are not equal" do
      it "returns false" do
        expect(eur == usd).to be(false)
      end
    end
  end
end
