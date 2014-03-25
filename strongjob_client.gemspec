$:.push File.dirname(__FILE__) + '/lib'
require 'strongjob_client/version'

Gem::Specification.new do |s|
  s.name = "strongjob_client"
  s.version = StrongjobClient::VERSION
  s.date = "2014-01-24"

  s.summary = "Client for StrongJob."
  s.description = "Uses the StrongJob API to record job runs."

  s.authors = ["Paul A. Jungwirth"]
  s.homepage = "http://github.com/pjungwir/strongjob-ruby-client"
  s.email = "pj@illuminatedcomputing.com"

  s.licenses = ["MIT"]

  s.require_paths = ["lib"]
  s.executables = []
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,fixtures}/*`.split("\n")

  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'json'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'bundler', '>= 0'

end

