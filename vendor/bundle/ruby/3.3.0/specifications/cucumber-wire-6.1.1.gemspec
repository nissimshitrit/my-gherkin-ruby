# -*- encoding: utf-8 -*-
# stub: cucumber-wire 6.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "cucumber-wire".freeze
  s.version = "6.1.1".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matt Wynne".freeze]
  s.date = "2021-08-27"
  s.description = "Wire protocol for Cucumber".freeze
  s.email = "cukes@googlegroups.com".freeze
  s.homepage = "http://cucumber.io".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "cucumber-wire-6.1.1".freeze

  s.installed_by_version = "3.5.22".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<cucumber-core>.freeze, ["~> 10.0".freeze, ">= 10.0.1".freeze])
  s.add_runtime_dependency(%q<cucumber-cucumber-expressions>.freeze, ["~> 12.1".freeze, ">= 12.1.2".freeze])
  s.add_runtime_dependency(%q<cucumber-messages>.freeze, ["~> 17.0".freeze, ">= 17.0.1".freeze])
  s.add_development_dependency(%q<aruba>.freeze, ["~> 2.0".freeze, ">= 2.0.0".freeze])
  s.add_development_dependency(%q<cucumber>.freeze, ["~> 7.0".freeze, ">= 7.0.0".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0".freeze, ">= 13.0.6".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.10".freeze, ">= 3.10.0".freeze])
end
