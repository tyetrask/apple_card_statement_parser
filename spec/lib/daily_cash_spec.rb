RSpec.describe AppleCardStatementParser::DailyCash do
  describe "#new" do
    it "returns an instance of DailyCash" do
      expect(AppleCardStatementParser::DailyCash.new(nil, nil)).to be_a(AppleCardStatementParser::DailyCash)
    end
  end
end
