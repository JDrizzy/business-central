lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'business_central/version'

Gem::Specification.new do |spec|
  spec.name          = 'business-central'
  spec.version       = BusinessCentral::VERSION
  spec.authors       = ['Jarrad Muir']
  spec.email         = ['jarrads@live.com']

  spec.summary       = 'Integration library for Microsoft Dynamic365 business central'
  spec.homepage      = 'https://github.com/JDrizzy/business-central'
  spec.license       = 'MIT'

  spec.metadata['source_code_uri'] = 'https://github.com/JDrizzy/business-central'
  spec.metadata['changelog_uri'] = 'https://github.com/JDrizzy/business-central/releases'

  spec.files = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  spec.test_files = `git ls-files -- test/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.2'
  spec.add_development_dependency 'byebug', '~> 11.1'
  spec.add_development_dependency 'minitest', '~> 5.14'
  spec.add_development_dependency 'minitest-focus', '~> 1.2'
  spec.add_development_dependency 'minitest-reporters', '~> 1.4'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'simplecov', '~> 0.21'
  spec.add_development_dependency 'webmock', '~> 3.12'
  spec.add_runtime_dependency 'oauth2', '~> 1.4'
end
