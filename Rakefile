require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:examples_specs) do |t|
  t.pattern = Dir.glob('examples/spec/**/*_spec.rb')
end

require 'rubygems'
require 'rubygems/package_task'

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = 'A mock SMTP server that can be run and inspected from tests.'
  s.name = 'mailcrate'
  s.version = '0.0.2'
  s.requirements << 'none'
  s.require_path = 'lib'
  s.files = 'lib/mailcrate.rb'
  s.description = 'A mock SMTP server that can be run and inspected from tests. The server runs in memory and received messages can be retrieved.'
  s.email = 'adam.d.scott@gmail.com'
  s.homepage = 'https://github.com/adscott/mailcrate'
  s.authors = 'Adam Scott'
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :default => :spec
