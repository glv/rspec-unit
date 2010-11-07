require 'rspec/unit/assertions'

module RSpec
  
  module Core
    class ExampleGroup
      include ::RSpec::Unit::Assertions
    end
  end
  
  module Unit
    class AssertionFailedError < RSpec::Matchers::MatcherError
    end
    
    class TestCase < RSpec::Core::ExampleGroup
      
      TEST_METHOD_PATTERN = /^test_/

      alias_example_to :test, :test_unit => true
      
      def self.inherited(klass)
        super
        
        install_setup_and_teardown(klass)
                  
        klass.set_it_up(test_case_name(klass), {:caller => caller})
        klass.metadata[:example_group][:test_unit] = true
        children << klass
        world.example_groups << klass
      end
      
      def self.test_case_info(options)
        metadata[:example_group].update(options)
      end
      
      def self.test_info(options)
        @_metadata_for_next = options
      end
      
      def self.method_added(id)
        name = id.to_s
        if test_method?(name)
          caller_lines[name] = caller
          test_method_metadata[name] = @_metadata_for_next
          @_metadata_for_next = nil
        end
      end
      
      def self.examples
        @tc_examples ||= ExamplesCollection.new(self, super)
      end
      
      def self.ancestors
        super[0..-2]
      end
      
      def self.test_case_name(klass)
        class_name = klass.name
        (class_name.nil? || class_name.empty?) ? '<Anonymous TestCase>' : class_name
      end
      
      def self.caller_lines
        @_caller_lines ||= {}
      end
      
      def self.find_caller_lines(name)
        klass = self
        while klass.respond_to?(:caller_lines)
          lines = klass.caller_lines[name]
          return lines unless lines.nil?
          klass = klass.superclass
        end
        []
      end
          
      def self.test_method_metadata
        @_test_method_metadata ||= {}
      end
      
      def self.install_setup_and_teardown(klass)
        # Only do this for direct descendants, because test/unit chains
        # fixtures through explicit calls to super.
        if self == ::RSpec::Unit::TestCase
          klass.class_eval do
            before {setup}
            after {teardown}
          end
        end
      end
      
      def self.test_method?(method_name)
        method_name =~ TEST_METHOD_PATTERN &&
        public_method_defined?(method_name) &&
        (-1..0).include?(instance_method(method_name).arity)
      end
              
      def self.test_methods
        public_instance_methods(true).select{|m| test_method?(m)}.map{|m| m.to_s}
      end
      
      def self.number_of_tests
        test_methods.size
      end
      
      def self.tests
        @tests ||= test_methods.sort.map do |m|
          meta = (test_method_metadata[m] || {}).merge({:caller => find_caller_lines(m),
                                                        :full_description => "#{display_name}##{m}",
                                                        :test_unit => true})
          Core::Example.new(self, m, meta, proc{execute(m)})
        end
      end

      class <<self
        private :test_case_name, :test_method_metadata,
                :install_setup_and_teardown, :test_method?, :test_methods,
                :number_of_tests, :tests
        protected :caller_lines, :find_caller_lines
      end
          
      def initialize
        @test_passed = true
        super
      end
      
      def setup
      end

      def teardown
      end    
      
      def execute(method)
        begin
          send(method.to_sym)
        rescue
          @test_passed = false
          raise
        end
      end
      
      private

      def passed?  
        @test_passed
      end
      
      class ExamplesCollection
        include Enumerable

        attr_accessor :testcase, :core_examples
        
        def initialize(testcase, core_examples)
          @testcase, @core_examples = testcase, core_examples
        end
        
        def tests
          testcase.send(:tests)
        end
        
        def number_of_tests
          testcase.send(:number_of_tests)
        end
        
        def size
          core_examples.size + number_of_tests
        end
        
        def empty?
          core_examples.empty? && number_of_tests == 0
        end
        
        def last
          tests.last || core_examples.last
        end
        
        def <<(example)
          core_examples << example
        end
        
        def each
          core_examples.each{|ex| yield(ex)}
          tests.each{|test| yield(test)}
        end
        
        def to_ary
          core_examples + tests
        end
        
        def uniq
          to_ary.uniq
        end
      end
    
    end
    
    RSpec.world.example_groups.delete(::RSpec::Unit::TestCase)
  end
  
end
