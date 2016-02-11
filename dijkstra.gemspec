# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dijkstra/version'

Gem::Specification.new do |spec|
  spec.name          = "dijkstra"
  spec.version       = Dijkstra::VERSION
  spec.authors       = ["Joshua Brewton"]
  spec.email         = ["Joshua.Brewton@sage.com"]

  spec.summary       = %q{Dijkstra exercise}
  spec.description   = %q{A longer dijkstra exercise}
  spec.homepage      = "https://github.com/jbrewton"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "n/a"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         =  Dir['lib/**/*.rb']
  # spec.bindir        = "bin"
  spec.executables   = ["dijkstra"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
