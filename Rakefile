require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:examples_specs) do |t|
  t.pattern = Dir.glob('examples/spec/**/*_spec.rb')
end

task :default => :spec
