$:.unshift( File.expand_path( "../lib", __FILE__ ) )
require "lab42/curry/version"
version = Lab42::Curry::VERSION
Gem::Specification.new do |s|
  s.name        = 'lab42_curry'
  s.version     = version
  s.summary     = 'Name says it all, curry at will'
  s.description = %{Curry functions and methods at will, reorder, define placeholders anywhere, positional and named args}
  s.authors     = ["Robert Dober"]
  s.email       = 'robert.dober@gmail.com'
  s.files       = Dir.glob("lib/**/*.rb")
  s.files      += %w{LICENSE README.md}
  s.homepage    = "https://github.com/robertdober/lab42_curry"
  s.licenses    = %w{Apache-2.0}

  s.required_ruby_version = '>= 2.7.0'
  # s.add_dependency 'lab42_result', '~> 0.1'

  s.add_development_dependency 'pry', '~> 0.13.1'
  s.add_development_dependency 'pry-byebug', '~> 3.9'
  s.add_development_dependency 'rspec', '~> 3.10'
  # s.add_development_dependency 'timecop', '~> 0.9.2'
  # s.add_development_dependency 'travis-lint', '~> 2.0'
end
