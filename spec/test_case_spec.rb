require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe Rspec::Core::ExampleGroup do
  it "supports using assertions in examples" do
    lambda {assert_equal 1, 1}.should_not raise_error
  end
end

describe Rspec::Unit::TestCase do
  before do
    @foo = Class.new(Rspec::Unit::TestCase)
    @foo_definition_line = __LINE__ - 1
    @caller_at_foo_definition = caller
    @formatter = Rspec::Core::Formatters::BaseFormatter.new
  end
  
  after do
    remove_last_describe_from_world
  end
  
  def run_tests(klass)
    klass.examples_to_run.replace(klass.examples)
    klass.run(@formatter)
  end
  
  describe "identifying test methods" do
    it "ignores methods that don't begin with 'test_'" do
      @foo.class_eval do
        def bar; end
      end
      @foo.examples.should be_empty
    end
  
    it "notices methods that begin with 'test_'" do
      @foo.class_eval do
        def test_bar; end
      end
      @foo.examples.size.should == 1
      @foo.examples.first.metadata[:description].should == 'test_bar'
    end
  
    it "ignores non-public test methods" do
      @foo.class_eval do
        protected
        def test_foo; end
        private       
        def test_bar; end
      end
      @foo.examples.should be_empty
    end
  
    it "ignores methods with good names but positive arity" do
      @foo.class_eval do
        def test_foo(a); end
        def test_bar(a, *b); end
      end
      @foo.examples.should be_empty
    end
  
    it "creates an example to represent a test method" do
      @foo.class_eval do
        def test_bar; end
      end
      @foo.examples.size.should == 1
      @foo.examples.first.metadata[:description].should == 'test_bar'
    end
  
    it "creates examples for inherited methods" do
      @foo.class_eval do
        def test_bar; end
      end
      isolate_example_group do
        bar = Class.new(@foo)
        bar.examples.size.should == 1
        bar.examples.first.metadata[:description].should == 'test_bar'
      end
    end
  
    it "creates examples for methods newly added to superclasses" do
      isolate_example_group do
        bar = Class.new(@foo)
        @foo.class_eval do
          def test_bar; end
        end
        bar.examples.size.should == 1
        bar.examples.first.metadata[:description].should == 'test_bar'
      end
    end
  
    it "creates examples for methods added by inclusion of a module" do
      bar = Module.new do
        def test_bar; end
      end
      @foo.send(:include, bar)
      @foo.examples.size.should == 1
      @foo.examples.first.metadata[:description].should == 'test_bar'
    end
  end
  
  describe "running test methods" do
    it "runs the test methods as examples" do
      use_formatter(@formatter) do
        @foo.class_eval do
          def test_bar; end
        end
        @foo.expects(:test_bar).once
        run_tests(@foo)
      end
    end
    
    it "brackets test methods with setup/teardown" do
      use_formatter(@formatter) do
        @foo.class_eval do
          def test_bar; end
          def test_baz; end
        end
      
        test_run = sequence('test_run')
      
        @foo.expects(:setup)   .once.in_sequence(test_run)
        @foo.expects(:test_bar).once.in_sequence(test_run)
        @foo.expects(:teardown).once.in_sequence(test_run)
        @foo.expects(:setup)   .once.in_sequence(test_run)
        @foo.expects(:test_baz).once.in_sequence(test_run)
        @foo.expects(:teardown).once.in_sequence(test_run)
      
        run_tests(@foo)
      end
    end
    
    it "records failed tests in Rspec style" do
      use_formatter(@formatter) do
        @foo.class_eval do
          def test_bar; flunk; end
        end
        run_tests(@foo)
        @formatter.failed_examples.size.should == 1
      end
    end
    
    it "indicates failed tests in test/unit style" do
      use_formatter(@formatter) do
        @foo.class_eval do
          class <<self; attr_accessor :_passed; end
          def test_bar; flunk; end
          def teardown; self.class._passed = passed?; end
        end
        run_tests(@foo)
        @foo._passed.should == false
      end
    end

    it "records passed tests in Rspec style" do
      use_formatter(@formatter) do
        @foo.class_eval do
          def test_bar; assert true; end
        end
        run_tests(@foo)
        @formatter.failed_examples.should be_empty
      end
    end
    
    it "indicates passed tests in test/unit style" do
      use_formatter(@formatter) do
        @foo.class_eval do
          class <<self; attr_accessor :_passed; end
          def test_bar; assert true; end
          def teardown; self.class._passed = passed?; end
        end
        run_tests(@foo)
        @foo._passed.should == true
      end
    end
  end
  
  describe "ancestors" do
    before do
      @bar = Class.new(@foo)
      remove_last_describe_from_world
    end
    
    it "removes TestCase from the beginning if superclass_last is false" do
      @bar.ancestors.should == [@foo, @bar]
    end
    
    it "removes TestCase from the end if superclass_last is true" do
      @bar.ancestors(true).should == [@bar, @foo]
    end
  end

  describe "test class metadata" do
    isolate_example_group do
      class SampleTestCaseForName < Rspec::Unit::TestCase
      end
    end

    it "sets :name to 'TestCase' and the class name if the class has one" do
      SampleTestCaseForName.metadata[:example_group][:name].should == "TestCase SampleTestCaseForName"
    end
    
    it "sets :name to 'Anonymous TestCase' for anonymous test classes" do
      @foo.metadata[:example_group][:name].should == "Anonymous TestCase"
    end
    
    it "sets :description to be the same as :name" do
      @foo.metadata[:example_group][:description].should == @foo.metadata[:example_group][:name]
      SampleTestCaseForName.metadata[:example_group][:description].should == SampleTestCaseForName.metadata[:example_group][:name]
    end
    
    it "adds :test_unit => true" do
      @foo.metadata[:example_group][:test_unit].should be_true
    end
    
    it "sets :file_path to the file in which the class is first defined" do
      @foo.metadata[:example_group][:file_path].should == __FILE__
    end
    
    it "sets :line_number to the line where the class definition begins" do
      @foo.metadata[:example_group][:line_number].should == @foo_definition_line
    end
    
    it "sets :location to file_path and line_number" do
      @foo.metadata[:example_group][:location].should == "#{__FILE__}:#{@foo_definition_line}"
    end
    
    it "sets :caller" do
      @foo.metadata[:example_group][:caller].first.should =~ Regexp.new(Regexp.escape(@foo.metadata[:example_group][:location]))
      @foo.metadata[:example_group][:caller].size.should == @caller_at_foo_definition.size + 3
    end
    
    it "has nil for :block and :describes" do
      @foo.metadata[:example_group][:block].should be_nil
      @foo.metadata[:example_group][:describes].should be_nil
    end
    
    it "records test_case_info options" do
      @foo.class_eval do
        test_case_info :foo => :bar
      end
      @foo.metadata[:example_group][:foo].should == :bar
    end    
  end
  
  describe "test method metadata" do
    def find_example(example_group, name)
      example_group.examples.find{|e|e.description == name}
    end
    
    def test_baz_metadata
      find_example(@foo, 'test_baz').metadata
    end
        
    it "uses a test method's name as its :description" do
      @foo.class_eval do
        def test_baz; end
      end
      @foo.examples.first.metadata[:description].should == 'test_baz'
    end

    it "uses a test method's name with the class name as its :full_description" do
      @foo.class_eval do
        def test_baz; end
      end
      test_baz_metadata[:full_description].should == 'Anonymous TestCase#test_baz'
    end
    
    it "adds :test_unit => true" do
      @foo.class_eval do
        def test_baz; end
      end
      test_baz_metadata[:test_unit].should be_true
    end    

    it "sets :file_path to the file where the method is defined" do
      @foo.class_eval do
        def test_baz; end
      end
      test_baz_metadata[:file_path].should == __FILE__
    end
    
    it "sets :line_number to the line where the method definition begins" do
      @foo.class_eval do
        def test_baz
        end
      end
      test_baz_metadata[:line_number].should == (__LINE__ - 3)
    end
    
    it "sets :location to file path and line number" do
      @foo.class_eval do
        def test_baz; end
      end
      test_baz_metadata[:location].should == "#{__FILE__}:#{__LINE__-2}"
    end
    
    it "sets :example_group and :behaviour to the test case class's metadata" do
      @foo.class_eval do
        def test_baz; end
      end
      test_baz_metadata[:example_group].should == @foo.metadata[:example_group]
      test_baz_metadata[:behaviour].should == @foo.metadata[:example_group]
    end
    
    it "sets :caller" do
      @foo.class_eval do
        def test_baz; end
      end
      test_baz_metadata[:caller].first.should == @foo.examples.first.metadata[:location]
      test_baz_metadata[:caller].size.should == caller.size + 3
    end        

    it "records test_info options for next test method" do
      @foo.class_eval do
        test_info :foo => :bar
        def test_baz; end
      end
      test_baz_metadata[:foo].should == :bar
    end
    
    it "records test_info options *only* for next test method" do
      @foo.class_eval do
        test_info :foo => :bar
        def test_baz; end
        def test_quux; end
      end
      find_example(@foo, 'test_quux').metadata[:foo].should be_nil
    end    
  end
  
  describe "examples within a test case" do
    it "allows 'example' to create an example" do
      @foo.class_eval do
        example "should bar" do end
      end
      @foo.examples.size.should == 1
      @foo.examples.first.metadata[:description].should == 'should bar'
    end
    
    it "supports 'test' as an alias of example" do
      @foo.class_eval do
        test "should bar" do end
      end
      @foo.examples.size.should == 1
      @foo.examples.first.metadata[:description].should == 'should bar'
      @foo.examples.first.metadata[:test_unit].should be_true
    end
    
    it "heeds 'alias_example_to'" do
      @foo.class_eval do
        alias_example_to :make_test
        make_test "should bar" do end
      end
      @foo.examples.size.should == 1
      @foo.examples.first.metadata[:description].should == 'should bar'
    end
    
    it "allows defining 'before' blocks" do
      use_formatter(@formatter) do
        @foo.class_eval do
          before {bar}
          def test_bar; end
        end
      
        @foo.expects(:bar).once
        run_tests(@foo)
      end
    end
    
    it "allows defining 'after' blocks" do
      use_formatter(@formatter) do
        @foo.class_eval do
          after {bar}
          def test_bar; end
        end

        @foo.expects(:bar).once
        run_tests(@foo)
      end
    end
    
    it "allows examples to use instance variables created in 'setup'" do
      use_formatter(@formatter) do
        @foo.class_eval do
          def setup; super; @quux = 42; end
          it "quux" do @quux.should == 42 end
        end
        run_tests(@foo)
        @formatter.failed_examples.should be_empty
      end
    end
    
    it "allows test methods to use instance variables created in 'before' blocks" do
      use_formatter(@formatter) do
        @foo.class_eval do
          before { @quux = 42 }
          def test_quux; assert_equal 42, @quux; end
        end
        run_tests(@foo)
        @formatter.failed_examples.should be_empty
      end
    end
  end

end
