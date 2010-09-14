require 'rubygems'
require 'bundler/setup'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec-unit'

def mock_example_group_instance(example_group)
  eg_inst = example_group.new
  example_group.stub(:new).and_return(eg_inst)
  eg_inst
end

class NullObject
  def method_missing(method, *args, &block)
    # ignore
  end
end

class RSpec::Core::ExampleGroup
  def self.run_all(reporter=nil)
    @orig_space = RSpec::Mocks.space
    RSpec::Mocks.space = RSpec::Mocks::Space.new
    run(reporter || NullObject.new)
  ensure
    RSpec::Mocks.space = @orig_space
  end
end

def sandboxed(&block)
  begin
    @orig_config = RSpec.configuration
    @orig_world  = RSpec.world
    new_config = RSpec::Core::Configuration.new
    new_world  = RSpec::Core::World.new(new_config)
    RSpec.instance_variable_set(:@configuration, new_config)
    RSpec.instance_variable_set(:@world, new_world)
    object = Object.new
    object.extend(RSpec::Core::ObjectExtensions)
    object.extend(RSpec::Core::SharedExampleGroup)

    object.instance_eval(&block)
  ensure
    RSpec.instance_variable_set(:@configuration, @orig_config)
    RSpec.instance_variable_set(:@world, @orig_world)
  end
end

def in_editor?
  ENV.has_key?('TM_MODE') || ENV.has_key?('EMACS') || ENV.has_key?('VIM')
end

RSpec.configure do |c|
  c.color_enabled = !in_editor?
  c.filter_run :focused => true
  c.run_all_when_everything_filtered = true
  c.alias_example_to :fit, :focused => true
  c.formatter = :documentation
  c.around do |example|
    sandboxed { example.run }
  end
end

