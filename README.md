# rspec-unit

test/unit compatibility for RSpec 2.

## Summary

rspec-unit adds support for test/unit-style assertions and test
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
examples.

## Rationale

This gem is the rough equivalent, for RSpec 2, of the test/unit
compatibility that was a part of the core RSpec gem in RSpec 1.
The new RSpec runner design makes it quite easy to implement this
functionality as a separate gem, which seems like a better choice
in many ways.

Currently, test/unit compatibility is much more limited than in 
RSpec 1.  The goal is not to make RSpec 2 a drop-in replacement for
test/unit; rather, we have two more limited goals:

1. to allow RSpec 2 examples to easily make use of test/unit assertions
   in cases where those assertions are valuable, or where assertions
   might be the best way to express particular expectations.
2. to make it *easy* for a project to switch an existing test/unit
   suite over to run under RSpec, as the start of a gradual, piecemeal
   conversion to RSpec.
   
As such, there are some things we don''t support:

* The top-level module name is different.  For example, one requires 
  `rspec/unit` rather than `test/unit`, and extends `RSpec::Unit::TestCase` 
  rather than `Test::Unit::TestCase`.
* TestSuite is not supported.  The RSpec 2 metadata features are 
  far more flexible than test/unit-style suites.
* Because of the very different implementation, many test/unit extensions
  will not run properly.
* All test output and summaries are in RSpec style; test/unit-compatible
  output is not supported.
  
We will certainly consider supporting those things if there is demand.

I originally wrote this test/unit compatibility gem for Micronaut, a
lightweight RSpec clone by Chad Humphries.  Micronaut has been rolled
into RSpec as the core of RSpec 2, and I was able to move the test/unit
compatibility over with minimal changes.

The point of this gem is not that I think test/unit is a better way
to write tests than the RSpec style.  I admit that I'm a TDD oldtimer
who sees RSpec as mostly a cosmetic (rather than fundamental) change,
but that doesn't mean it's not an important change.  My curmudgeonly
nature has its limits, and I do find specs a big improvement.

So why rspec-unit?  Three reasons:

1. I wanted to show off the generality of Micronaut's (and now RSpec's)
   architecture.  I hope rspec-unit can serve as an example for anyone 
   who wants to experiment with new ways of expressing tests and specs 
   on top of RSpec.
2. Many projects with existing test/unit test suites might want to
   benefit from the [metadata goodness][metadata] in RSpec 2, or begin
   a gradual, piecemeal change to an RSpec style.  That's pretty
   easy to do with rspec-unit.
3. Even when writing specs and examples, I frequently encounter
   cases where an assertion is more expressive than a `should`
   expression.  It's nice just to have assertions supported within
   RSpec examples.
      
[uth]: http://blog.thinkrelevance.com/2009/4/1/micronaut-innovation-under-the-hood
[metadata]: http://blog.thinkrelevance.com/2009/3/26/introducing-micronaut-a-lightweight-bdd-framework

## To Do

It would be nice to try using the assertion code from minitest,
which is much more compact and seems less coupled than that from
test/unit.

### Copyright

Copyright (c) 2009, 2010 Glenn Vanderburg. See LICENSE for details.
