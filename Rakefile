require 'rubygems'
require 'rake'
require 'rspec'
require 'rspec/core/rake_task'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "jsonrpc/version"


RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(-fs --color)
end

desc "Build the gem"
task :build do
  system "gem build jsonrpc.gemspec"
end

desc "Release the gem"
task :release => :build do
  system "gem push jsonrpc-#{JsonRPC::VERSION}.gem"
end
