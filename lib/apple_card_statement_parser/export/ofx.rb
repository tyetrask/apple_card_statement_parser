require "date"

module AppleCardStatementParser
  module Export
    class OFX
      def initialize(statement)
        @statement = statement
      end

      def as_ofx
        raise "OFX support has not yet been implemented (https://github.com/tyetrask/apple_card_statement_parser/issues/7)"
      end

      def write(filepath)
        File.open(filepath, "w") { |f| f.write(JSON.generate(as_json)) }
      end
    end
  end
end
