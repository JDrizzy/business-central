lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "business_central/version"

Gem::Specification.new do |spec|
  spec.name          = "business-central"
  spec.version       = BusinessCentral::VERSION
  spec.authors       = ["Jarrad Muir"]
  spec.email         = ["jarrads@live.com"]

  spec.summary       = "Integration library for Microsoft Dynamic365 business central"
  spec.homepage      = "https://github.com/JDrizzy/business-central"
  spec.license       = "MIT"

  spec.metadata["source_code_uri"] = "https://github.com/JDrizzy/business-central"
  spec.metadata["changelog_uri"] = "https://github.com/JDrizzy/business-central/releases"

  spec.files = Dir["LICENSE.txt", "README.md", 'lib/**/*']
  spec.test_files = `git ls-files -- test/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "webmock", "~> 3.7", ">= 3.7.6"
  spec.add_development_dependency "byebug", "~> 11.0", ">= 11.0.1"
  spec.add_development_dependency "simplecov", "~> 0.17.1"
  spec.add_runtime_dependency "oauth2", "~> 1.4", ">= 1.4.2"
end
