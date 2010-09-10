require 'bundler/setup'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rspec-unit"
    gem.summary = %Q{test/unit compatibility for RSpec 2.}
    gem.description = File.read('README.md').sub(/\A.*^## Summary\s*$\s*(.*?)\s*^#+\s.*\Z/m, '\1')
    gem.email = "glv@vanderburg.org"
    gem.homepage = "http://github.com/glv/rspec-unit"
    gem.authors = ["Glenn Vanderburg"]
    gem.rubyforge_project = "rspec-unit"
    gem.add_dependency('rspec', '>= 2.0.0.beta.20')
    gem.has_rdoc = false
    gem.files =  FileList["[A-Z]*", "{bin,lib,spec}/**/*"] 
    gem.rubyforge_project = 'glv' 
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

  Jeweler::RubyforgeTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.ruby_opts = '-Ilib -Ispec'
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov_opts = '-Ilib -Ispec -x ' + "'#{Regexp.escape(Bundler.settings.path)},^spec/'"
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rspec-unit #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

