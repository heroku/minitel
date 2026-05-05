# frozen_string_literal: true

require File.expand_path("../lib/minitel/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "minitel"
  gem.authors = ["Will Leinweber"]
  gem.email = ["will@bitfission.com"]
  gem.description = "𝕋𝔼𝕃𝔼𝕏 client"
  gem.summary = "𝕋𝔼𝕃𝔼𝕏 client: see https://github.com/heroku/telex"
  gem.homepage = "https://github.com/heroku/minitel"

  gem.files = `git ls-files`.split($\)
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]
  gem.version = Minitel::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.license = "MIT"

  gem.required_ruby_version = ">= 3.2"

  gem.add_runtime_dependency "json"
end
