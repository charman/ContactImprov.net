# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "acts_as_versioned"
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rick Olson"]
  s.date = "2010-07-19"
  s.description = "Add simple versioning to ActiveRecord models."
  s.email = "technoweenie@gmail.com"
  s.extra_rdoc_files = ["README", "MIT-LICENSE", "CHANGELOG"]
  s.files = ["README", "MIT-LICENSE", "CHANGELOG"]
  s.homepage = "http://github.com/technoweenie/acts_as_versioned"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "acts_as_versioned"
  s.rubygems_version = "1.8.11"
  s.summary = "Add simple versioning to ActiveRecord models."

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["~> 3.0.0.beta4"])
      s.add_development_dependency(%q<sqlite3-ruby>, ["~> 1.3.1"])
    else
      s.add_dependency(%q<activerecord>, ["~> 3.0.0.beta4"])
      s.add_dependency(%q<sqlite3-ruby>, ["~> 1.3.1"])
    end
  else
    s.add_dependency(%q<activerecord>, ["~> 3.0.0.beta4"])
    s.add_dependency(%q<sqlite3-ruby>, ["~> 1.3.1"])
  end
end
