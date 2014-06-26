$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_machine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_machine"
  s.version     = RailsMachine::VERSION
  s.authors     = ["Grzegorz Łuszczek"]
  s.email       = ["grzegorz@piklus.pl"]
  s.homepage    = "https://github.com/grzlus/rails_machine"
  s.summary     = "State machine for Rails."
  s.description = "Simple implementation of state machine for Rails using enums."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 4.1"
	s.required_ruby_version = '>= 2.1'

  s.add_development_dependency "sqlite3"
end
