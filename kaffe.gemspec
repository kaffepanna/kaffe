# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'kaffe/version'

Gem::Specification.new do |spec|
  spec.name          = "kaffe"
  spec.version       = Kaffe::VERSION
  spec.authors       = ["Patrik Pettersson"]
  spec.email         = ["pettersson.pa@gmail.com"]

  spec.summary       = %q{Minimalistic webframework inspired by sinatra and rails}
  spec.description   = `cat README.md`
  spec.homepage    = 'https://github.com/kaffepanna/kaffe'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack", '~> 1.5'
  spec.add_runtime_dependency "tilt", '~> 1.4'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
