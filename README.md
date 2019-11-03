# Apple Card Statement Parser

⚠️ This library is a work-in-progress!

A Ruby Gem to read, parse, and convert Apple Card PDF statements into machine-readable formats.

### Why?

As of November 2019, Apple does not provide any export format for Apple Card other than monthly statement PDFs. For those interested in using this data in finance or budgeting software, the goal is to provide a slightly easier way to add Apple Card transactions to those applications by converting to commonly importable formats.

### TODO

- [ ] JSON export
- [ ] Other formats such as OFX, CSV?
- [ ] Validation of total payments and transactions?
- [ ] Handle non-US currencies
- [ ] Detection of PDF version

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

Create an instance of `Statement` and `read!`:
```ruby
@statement = AppleCardStatementParser::Statement.new("tmp/Apple Card Statement - August 2024.pdf")
@statement.read!
```

Then access properties of interest for the statement:
```ruby
puts @statement.period
#=> TODO
puts @statement.transactions
#=> [...]
```

Or output as JSON for import into your preferred finance software:
```ruby
@statement.as_json
#=> {...}
@statement.write_json!("tmp/apple_card_statement.json")
#=> true
```

```json
{
    # TODO JSON formatted example here
}
```

#### CLI

You can also use the binary to convert PDFs directly to JSON:
```sh
bin/apple_card_statement_to_json "tmp/Apple Card Statement - August 2024.pdf"
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
