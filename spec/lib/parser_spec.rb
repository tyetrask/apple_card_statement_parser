RSpec.describe AppleCardStatementParser::Parser do
  let(:filepath) { "/anything/Apple Card Statement.pdf" }
  let(:pdf_reader) { instance_double(PDF::Reader) }
  let(:page_1) { instance_double(PDF::Reader::Page) }
  let(:page_2) { instance_double(PDF::Reader::Page) }
  let(:page_3) { instance_double(PDF::Reader::Page) }
  let(:page_4) { instance_double(PDF::Reader::Page) }
  let(:page_5) { instance_double(PDF::Reader::Page) }
  let(:page_6) { instance_double(PDF::Reader::Page) }
  let(:page_1_content) { File.read("#{FIXTURE_PATH}/sample_statement_1/page_1.txt") }
  let(:page_2_content) { File.read("#{FIXTURE_PATH}/sample_statement_1/page_2.txt") }
  let(:page_3_content) { File.read("#{FIXTURE_PATH}/sample_statement_1/page_3.txt") }
  let(:page_4_content) { File.read("#{FIXTURE_PATH}/sample_statement_1/page_4.txt") }
  let(:page_5_content) { File.read("#{FIXTURE_PATH}/sample_statement_1/page_5.txt") }
  let(:page_6_content) { File.read("#{FIXTURE_PATH}/sample_statement_1/page_6.txt") }

  before do
    allow(PDF::Reader).to receive(:new).and_return(pdf_reader)
    allow(pdf_reader).to receive(:pages).and_return([page_1, page_2, page_3, page_4, page_5, page_6])
    allow(page_1).to receive(:text).and_return(page_1_content)
    allow(page_2).to receive(:text).and_return(page_2_content)
    allow(page_3).to receive(:text).and_return(page_3_content)
    allow(page_4).to receive(:text).and_return(page_4_content)
    allow(page_5).to receive(:text).and_return(page_5_content)
    allow(page_6).to receive(:text).and_return(page_6_content)
  end

  describe "::perform" do
    let(:perform_result) { AppleCardStatementParser::Parser.perform(filepath) }

    it "returns a hash of data parsed from the PDF" do
      expect(perform_result).to be_a(Hash)
    end

    context "within the hash" do
      it "includes the statement period as a range" do
        expect(perform_result[:period]).to be_a(Range)
      end

      it "includes payments as an array of Payment instances" do
        expect(perform_result[:payments]).to be_a(Array)
        expect(perform_result[:payments].first).to be_a(AppleCardStatementParser::Payment)
      end

      it "includes transactions as an array of Transaction instances" do
        expect(perform_result[:transactions]).to be_a(Array)
        expect(perform_result[:transactions].first).to be_a(AppleCardStatementParser::Transaction)
      end

      it "includes return_transactions as an array of ReturnTransaction instances" do
        expect(perform_result[:return_transactions]).to be_a(Array)
        expect(perform_result[:return_transactions].first).to be_a(AppleCardStatementParser::ReturnTransaction)
      end
    end

    it "correctly parses period" do
      expect(perform_result[:period].first).to eq(Date.new(2024, 04, 01))
      expect(perform_result[:period].last).to eq(Date.new(2024, 04, 30))
    end

    it "correctly parses payments" do
      expect(perform_result[:payments].size).to eq(13)
      first_payment = perform_result[:payments].first
      expect(first_payment.date).to eq(Date.new(2024, 04, 03))
      expect(first_payment.description).to eq("ACH Deposit Internet transfer from account ending in 7778")
      expect(first_payment.amount.amount).to eq(-20896)
    end

    it "correctly parses transactions" do
      expect(perform_result[:transactions].size).to eq(73)
      first_transaction = perform_result[:transactions].first
      expect(first_transaction.date).to eq(Date.new(2024, 04, 01))
      expect(first_transaction.description).to eq("SVC*SERVICE 44556677 50005 E SOMEWHERE BLVD SVC.COM/BILL12345 USA")
      expect(first_transaction.amount.amount).to eq(599)
      expect(first_transaction.daily_cash.percentage.amount).to eq(2)
      expect(first_transaction.daily_cash.amount.amount).to eq(12)
    end

    it "correctly parses return transactions" do
      expect(perform_result[:return_transactions].size).to eq(1)
      first_return_transaction = perform_result[:return_transactions].first
      expect(first_return_transaction.date).to eq(Date.new(2024, 04, 29))
      expect(first_return_transaction.description).to eq("BUSINESSE1 RETURNEDTHIS SE FAKE ST CITYTOWN 12345 USA")
      expect(first_return_transaction.amount.amount).to eq(-34999)
      expect(first_return_transaction.daily_cash_adjustment.percentage.amount).to eq(-2)
      expect(first_return_transaction.daily_cash_adjustment.amount.amount).to eq(700)
    end
  end
end
