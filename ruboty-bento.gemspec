# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruboty/bento/version"

Gem::Specification.new do |spec|
  spec.name          = "ruboty-bento"
  spec.version       = Ruboty::Bento::VERSION
  spec.authors       = ["ysksg"]
  spec.email         = ["y.ksg1217@gmail.com"]

  spec.summary       = %q{Scraping the lunchbox menu.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/ysksg/"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_development_dependency "ruboty"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
