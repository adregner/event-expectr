$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'event-expectr/version'

Gem::Specification.new do |s|
  s.name = "event-expectr"
  s.version = EventExpectr::VERSION

  s.description = "Wraps the Expectr class so that you can \"register\" a list of several patterns to search for and have a block of code be executed when and if they match."
  s.summary = "Wrapper for Ruby's expectr gem that enables a different type of workflow."
  s.authors = ["Andrew Regner"]
  s.email = "andrew@aregner.com"
  s.homepage = "http://github.com/adregner/event-expectr"

  s.files = `git ls-files`.split("\n")
	#s.test_files = s.files.select { |f| f =~ /^test\/test_/ }

  s.license = 'MIT'
end
