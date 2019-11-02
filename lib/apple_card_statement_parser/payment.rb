module AppleCardStatementParser
  class Payment
    RETURN_STRING_MATCH = "RETURN".freeze
    include FormatValidators

    def initialize(raw_date, raw_description, raw_amount)
      @raw_date = raw_date
      @raw_description = raw_description
      @raw_amount = raw_amount
    end

    def date
      as_date(@raw_date)
    end

    def description
      @raw_description
    end

    def amount
      as_amount(@raw_amount)
    end

    def is_valid?
      is_a_date?(@raw_date) &&
        is_a_description?(@raw_description) &&
        !@raw_description.include?(RETURN_STRING_MATCH) &&
        is_an_amount?(@raw_amount)
    end
  end
end
