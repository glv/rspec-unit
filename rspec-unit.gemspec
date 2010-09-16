# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-unit}
  s.version = "0.9.22"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Glenn Vanderburg"]
  s.date = %q{2010-09-15}
  s.description = %q{test/unit compatibility for RSpec 2.}
  s.email = %q{glv@vanderburg.org}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION.yml",
     "lib/rspec-unit.rb",
     "lib/rspec/unit.rb",
     "lib/rspec/unit/assertions.rb",
     "lib/rspec/unit/test_case.rb",
     "spec/assertions_spec.rb",
     "spec/spec_helper.rb",
     "spec/test_case_spec.rb"
  ]
  s.homepage = %q{http://github.com/glv/rspec-unit}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{glv}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{test/unit compatibility for RSpec 2.}
  s.test_files = [
    "spec/assertions_spec.rb",
     "spec/spec_helper.rb",
     "spec/test_case_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, ["~> 2.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.0"])
  end
end

