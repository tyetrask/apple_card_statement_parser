require "apple_card_statement_parser/version"
require "apple_card_statement_parser/format_validators"
require "apple_card_statement_parser/currency_amount"
require "apple_card_statement_parser/daily_cash_percentage"
require "apple_card_statement_parser/daily_cash"
require "apple_card_statement_parser/payment"
require "apple_card_statement_parser/transaction"
require "apple_card_statement_parser/return_transaction"
require "apple_card_statement_parser/statement"

module AppleCardStatementParser
  NEWLINE_CHARACTER = "\n".freeze
  CURRENCY_CHARACTER = "$".freeze
  PERIOD_CHARACTER = ".".freeze

  RETURN_STRING_MATCH = "RETURN".freeze
  DAILY_CASH_ADJUSTMENT_INDICATOR_STRING = "Daily Cash Adjustment".freeze
end
