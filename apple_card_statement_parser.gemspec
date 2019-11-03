
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "apple_card_statement_parser/version"

Gem::Specification.new do |spec|
  spec.name          = "apple_card_statement_parser"
  spec.version       = AppleCardStatementParser::VERSION
  spec.authors       = ["Tye Trask"]
  spec.email         = ["inc3pt@gmail.com"]

  spec.summary       = %q{Read, parse, and convert Apple Card PDF statements into machine-readable formats}
  spec.homepage      = "https://github.com/tyetrask/apple_card_statement_parser"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "pdf-reader", "~> 2.2.1"
  spec.add_runtime_dependency "json", "~> 2.1.0"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
