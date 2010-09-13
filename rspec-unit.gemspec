# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-unit}
  s.version = "9.22.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Glenn Vanderburg"]
  s.date = %q{2010-09-13}
  s.description = %q{rspec-unit adds support for test/unit-style assertions and test
cases to RSpec 2.  This is useful for piecemeal conversions of your
test suite (in either direction), mixing styles, or if you simply
want to use test/unit-style assertions occasionally in your specs.

Just add this to your code:

    require 'rspec/unit'

and then you can write test classes like this:

    class FooTest < RSpec::Unit::TestCase
      def test_foo
        assert_equal 3, Foo::major_version
      end
    end

Using the `test_info` method, you can attach metadata to the next
defined test (this works much the same way Rake's `desc` method
attaches a description string to the next defined task):

    test_info :speed => 'slow', :run => 'nightly'
    def test_tarantula_multipass
      # ...
    end
    
You can also attach metadata to the entire class with the
`test_case_info` method:

    class BarTest < RSpec::Unit::TestCase
      test_case_info :integration => true
      
      # ...
    end

Each instance of `Rspec::Unit::TestCase` is equivalent to an
RSpec `describe` block, so it can also include `example` blocks,
`before` and `after` blocks, and nested `describe` blocks.  Test
methods and `example` blocks can contain either assertions or `should`
expressions.  `test` blocks (as found in Rails 2.x) also work.

Additionally, assertions can be used inside ordinary RSpec
examples.}
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

