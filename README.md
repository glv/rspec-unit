# rspec-unit

Test::Unit compatibility for rspec.

Just add this to your code:

    require 'rspec/unit'

and then you can write test classes like this:

    class FooTest < Rspec::Unit::TestCase
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

    class BarTest < Rspec::Unit::TestCase
      test_case_info :integration => true
      
      # ...
    end

Each instance of `Rspec::Unit::TestCase` is equivalent to a
rspec `describe` block, so it can also include `it` blocks,
`before` and `after` blocks, and nested `describe` blocks.  Test
methods and `it` blocks can contain either assertions or `should`
expressions.  `test` blocks (as found in Rails 2.x) also work.

Additionally, assertions can be used inside ordinary rspec
examples.

## Rationale

The point of this gem is not that I think test/unit is a better way
to write tests than the RSpec style.  I admit that I'm a TDD oldtimer
who sees RSpec as mostly a cosmetic (rather than fundamental) change,
but that doesn't mean it's not an important change.  My curmudgeonly
nature has its limits, and I do find specs a big improvement.

So why rspec-unit?  Three reasons:

1. I wanted to show off the generality of Rspec's architecture.
   On the surface, Rspec might not seem all that compelling
   (since it's basically an RSpec work-alike).  But it's really a
   fantastic tool; it's just that the 
   [innovation is all under the hood][uth], in a way that makes it
   easy to change the surface aspects.  I hope rspec-unit can
   serve as an example for anyone who wants to experiment with new
   ways of expressing tests and specs on top of Rspec.
2. Many projects with existing test/unit test suites might want to
   benefit from Rspec's [metadata goodness][metadata], or begin
   a gradual, piecemeal change to an RSpec style.  That's pretty
   easy to do with rspec-unit.
3. Even when writing specs and examples, I frequently encounter
   cases where an assertion is more expressive than a `should`
   expression.  It's nice just to have assertions supported within
   Rspec examples.
      
[uth]: http://blog.thinkrelevance.com/2009/4/1/micronaut-innovation-under-the-hood
[metadata]: http://blog.thinkrelevance.com/2009/3/26/introducing-micronaut-a-lightweight-bdd-framework

## To Do

It would be nice to try using the assertion code from minitest,
which is much more compact and seems less coupled than that from
test/unit.

### Copyright

Copyright (c) 2009 Glenn Vanderburg. See LICENSE for details.
