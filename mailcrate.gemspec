raise if ENV['SNAP_CI'] && File.basename(Dir.pwd) == "mailcrate" # TODO: disable snap ci ...

Gem::Specification.new 'mailcrate', '0.0.3' do |s|
  s.summary = 'A mock SMTP server that can be run and inspected from tests.'
  s.description = 'A mock SMTP server that can be run and inspected from tests. The server runs in memory and received messages can be retrieved.'
  s.files = 'lib/mailcrate.rb'
  s.email = 'adam.d.scott@gmail.com'
  s.homepage = 'https://github.com/adscott/mailcrate'
  s.authors = 'Adam Scott'
  s.license = 'MIT'
  s.required_ruby_version = '>= 2.0.0'
end
