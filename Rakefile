def rcr?
  ENV['RUN_CODE_RUN'] == 'true'
end

system("bundle check || bundle install --disable-shared-gems")

begin
  # Try to require the preresolved locked set of gems.
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  # Fall back on doing an unlocked resolve at runtime.
  puts "Something's wrong with bundle configuration.  Falling back to RubyGems."
  require "rubygems"
  require "bundler"
  Bundler.setup
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rspec-unit"
    gem.summary = %Q{Adds test/unit compatibility to Rspec.}
    gem.email = "glv@vanderburg.org"
    gem.homepage = "http://github.com/glv/rspec-unit"
    gem.authors = ["Glenn Vanderburg"]
    gem.rubyforge_project = "rspec-unit"
    gem.add_dependency('rspec', '>= 2.0.0.a7')
    gem.has_rdoc = false
    gem.files =  FileList["[A-Z]*", "{bin,lib,examples}/**/*"] 
    gem.rubyforge_project = 'glv' 
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

  Jeweler::RubyforgeTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'
Rspec::Core::RakeTask.new(:examples) do |examples|
  examples.pattern = 'spec/**/*_spec.rb'
  examples.ruby_opts = '-Ilib -Ispec'
end

Rspec::Core::RakeTask.new(:rcov) do |examples|
  examples.pattern = 'spec/**/*_spec.rb'
  examples.rcov_opts = '-Ilib -Ispec -x "/Library/Ruby/Gems,^spec/"'
  examples.rcov = true
end

task :default => :examples

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rspec-unit #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

