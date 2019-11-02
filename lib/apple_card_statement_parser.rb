require "apple_card_statement_parser/version"
require "apple_card_statement_parser/format_validators"
require "apple_card_statement_parser/currency_amount"
require "apple_card_statement_parser/daily_cash_percentage"
require "apple_card_statement_parser/daily_cash"
require "apple_card_statement_parser/payment"
require "apple_card_statement_parser/transaction"
require "apple_card_statement_parser/statement/v1"

module AppleCardStatementParser
  NEWLINE_CHARACTER = "\n".freeze
  CURRENCY_CHARACTER = "$".freeze
  PERIOD_CHARACTER = ".".freeze
  EMPTY_STRING = "".freeze
end
