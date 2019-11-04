# Apple Card Statement Parser

⚠️ This library is a work-in-progress and **not yet complete**! Please see open [issues](https://github.com/tyetrask/apple_card_statement_parser/issues) to learn what hasn't been completed yet.

A Ruby Gem to read, parse, and convert Apple Card PDF statements into machine-readable formats.

### Why?

As of November 2019, Apple does not provide any export format for Apple Card other than monthly statement PDFs. For those interested in using this data in finance or budgeting software, the goal is to provide a slightly easier way to add Apple Card transactions to those applications by converting to commonly importable formats.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apple_card_statement_parser'
```

And then execute:
```sh
$ bundle
```

Or install it yourself as:
```sh
$ gem install apple_card_statement_parser
```

## Usage

Create an instance of `Statement`:
```ruby
@statement = AppleCardStatementParser::Statement.read("tmp/Apple Card Statement - August 2024.pdf")
#=> #<AppleCardStatementParser::Statement ...>
```

Then access properties of interest for the statement:
```ruby
puts @statement.period
#=> #<Date: 2024-08-01 ((2458728j,0s,0n),+0s,2299161j)>..#<Date: 2024-08-30 ((2458757j,0s,0n),+0s,2299161j)>
puts @statement.payments
#=> [...]
puts @statement.transactions
#=> [...]
puts @statement.return_transactions
#=> [...]
puts @statement.total_payments.to_s
#=> -$765.43
puts @statement.total_charges_credits_and_returns.to_s
#=> $1234.56
puts @statement.total_daily_cash_earned.to_s
#=> $23.45
```

### Export

Export as JSON for import into your preferred finance software:
```ruby
@exporter = AppleCardStatementParser::Export::JSON.new(@statement)
@exporter.write("tmp/apple_card_statement.json")
```

```json
{
    "transactions": [
        {
            "id":"20240803:PAYMENT:-19996",
            "date":"2024-08-03",
            "type":"PAYMENT",
            "amount":"-$199.96",
            "description":"ACH Deposit Internet transfer from account ending in 1234"
        },
        {
            "id":"20240809:PAYMENT:445",
            "date":"2024-08-09",
            "type":"TRANSACTION",
            "amount":"-$4.45",
            "description":"STARBUCKS STORE MANHATTAN NY USA"
        }
    ]
}
```

Or CSV:
```ruby
@exporter = AppleCardStatementParser::Export::CSV.new(@statement)
@exporter.write("tmp/apple_card_statement.csv")
```

```csv
date,type,amount,description,id
2024-08-03,PAYMENT,-$199.96,ACH Deposit Internet transfer from account ending in 1234,20240803:PAYMENT:-19996
2024-08-09,TRANSACTION,$4.45,STARBUCKS STORE MANHATTAN NY USA,20240809:TRANSACTION:445
```

#### Command Line

You can also use the binary to convert PDFs directly to JSON or CSV:
```sh
bin/apple_card_statement_to_json "tmp/Apple Card Statement - August 2024.pdf"
# Creates tmp/Apple Card Statement - August 2024.json
bin/apple_card_statement_to_csv "tmp/Apple Card Statement - August 2024.pdf"
# Creates tmp/Apple Card Statement - August 2024.csv
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tyetrask/apple_card_statement_parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AppleCardStatementParser project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/apple_card_statement_parser/blob/master/CODE_OF_CONDUCT.md).
