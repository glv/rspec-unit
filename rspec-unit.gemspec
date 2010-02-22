# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{micronaut-unit}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Glenn Vanderburg"]
  s.date = %q{2009-05-23}
  s.email = %q{glv@vanderburg.org}
  s.extra_rdoc_files = [
     "LICENSE",
     "README.md"
  ]
  s.files = [
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION.yml",
     "examples/assertions_example.rb",
     "examples/example_helper.rb",
     "examples/test_case_example.rb",
     "lib/micronaut-unit.rb",
     "lib/micronaut/unit.rb",
     "lib/micronaut/unit/assertions.rb",
     "lib/micronaut/unit/test_case.rb"
  ]
  s.homepage = %q{http://github.com/glv/micronaut-unit}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{glv}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Adds test/unit compatibility to Micronaut.}
  s.test_files = [
    "examples/assertions_example.rb",
     "examples/example_helper.rb",
     "examples/test_case_example.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spicycode-micronaut>, [">= 0.2.9"])
    else
      s.add_dependency(%q<spicycode-micronaut>, [">= 0.2.9"])
    end
  else
    s.add_dependency(%q<spicycode-micronaut>, [">= 0.2.9"])
  end
end
