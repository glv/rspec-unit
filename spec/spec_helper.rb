begin
  # Try to require the preresolved locked set of gems.
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  # Fall back on doing an unlocked resolve at runtime.
  puts "Something's wrong with bundle configuration.  Falling back to RubyGems."
  require "rubygems"
  require "bundler"
  Bundler.setup
end

require 'rspec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec-unit'

def remove_last_describe_from_world
  Rspec::Core.world.example_groups.pop
end

def isolate_example_group
  if block_given?
    yield
    Rspec::Core.world.example_groups.pop
  end
end

def use_formatter(new_formatter)
  original_formatter = Rspec::Core.configuration.formatter
  Rspec::Core.configuration.instance_variable_set(:@formatter, new_formatter)
  yield
ensure
  Rspec::Core.configuration.instance_variable_set(:@formatter, original_formatter)
end

def in_editor?
  ENV.has_key?('TM_MODE') || ENV.has_key?('EMACS') || ENV.has_key?('VIM')
end

Rspec.configure do |c|
  c.mock_framework = :rspec
  c.filter_run :focused => true
  c.run_all_when_everything_filtered = true
  c.color_enabled = !in_editor?
  c.alias_example_to :fit, :focused => true
  c.profile_examples = false
  c.formatter = :documentation # if ENV["RUN_CODE_RUN"] == "true"
end

