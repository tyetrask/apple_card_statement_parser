RSpec.describe AppleCardStatementParser::Export::CSV do
  describe "#new" do
    it "returns an instance of the exporter" do
      expect(AppleCardStatementParser::Export::CSV.new(nil)).to be_a(AppleCardStatementParser::Export::CSV)
    end
  end

  describe "#write" do
    it "writes a file with the expected output" do
      # Setup occurs within the test assertion itself to allow
      # stubbing and unstubbing File methods in the correct order
      pages = []
      (1..6).to_a.each do |page_number|
        page = instance_double(PDF::Reader::Page)
        content = File.read("#{FIXTURE_PATH}/sample_statement_1/page_#{page_number}.txt")
        allow(page).to receive(:text).and_return(content)
        pages << page
      end
      pdf_reader = instance_double(PDF::Reader)
      allow(pdf_reader).to receive(:pages).and_return(pages)
      allow(PDF::Reader).to receive(:new).and_return(pdf_reader)
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read).and_return("file contents")
      statement = AppleCardStatementParser::Statement.read("filepath")
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:read).and_call_original

      expected_csv_content = File.read("#{FIXTURE_PATH}/sample_statement_1/expected_export.csv")
      filepath = "tmp/#{SecureRandom.uuid}.csv"
      AppleCardStatementParser::Export::CSV.new(statement).write(filepath)
      actual_csv_context = File.read(filepath)
      File.delete(filepath) if File.exist?(filepath)
      expect(actual_csv_context).to eq(expected_csv_content)
    end
  end
end
