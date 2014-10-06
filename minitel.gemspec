# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'minitel'

Gem::Specification.new do |gem|
  gem.name          = "minitel"
  gem.authors       = ["Will Leinweber"]
  gem.email         = ["will@bitfission.com"]
  gem.description   = %q{𝕋𝔼𝕃𝔼𝕏 client}
  gem.summary       = %q{𝕋𝔼𝕃𝔼𝕏 client: see https://github.com/heroku/telex}
  gem.homepage      = "https://github.com/heroku/minitel"

  gem.files         = `git ls-files`.split($\)
  #gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = Minitel::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.license       = "MIT"

  gem.add_runtime_dependency 'excon', '~> 0', ">= 0.16"
  gem.add_runtime_dependency 'multi_json', '~> 1.0'

  gem.add_development_dependency 'rspec', '~> 3.0'
end
