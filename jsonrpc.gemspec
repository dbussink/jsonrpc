# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'jsonrpc/version'

Gem::Specification.new do |s|
  s.name        = "jsonrpc"
  s.version     = JsonRPC::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dirkjan Bussink"]
  s.email       = ["d.bussink@gmail.com"]
  s.homepage    = "https://github.com/dbussink/jsonrpc"
  s.summary     = %q{JSON RPC Implementation}
  s.description = %q{Very simple JSON RPC client implementation}

  s.rubyforge_project         = "jsonrpc"

  s.add_dependency "addressable"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.0"

  # Man files are required because they are ignored by git
  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths      = ["lib"]
end
