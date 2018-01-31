
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "HashEx/version"

Gem::Specification.new do |spec|
  spec.name          = "HashEx"
  spec.version       = HashEx::VERSION
  spec.authors       = ["eGust"]
  spec.email         = ["egustc@gmail.com"]

  spec.summary       = %q{Enhanced Hash, HashEx::JsObject works like JS Object}
  spec.description   = %q{HashEx::Base is an abstract class need to override #convert_key.
HashEx::JsObject is a JavaScript-Object-like Hash. }
  spec.homepage      = "https://github.com/eGust/HashEx"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
