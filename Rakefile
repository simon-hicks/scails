require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "scails"
    gem.summary = %Q{live-coding/algorithmic composition for ruby}
    gem.description = %Q{Scails is a basic framework for live-coding/algorithmic composition, inspired by impromtu and Topher Cyll's amazing book "Practical Ruby Projects". It doesn't do anything that you couldn't do using other gems (in fact most of the code was lifted straight out of either MIDIator or scruby), but it does things the way I want them done...}
    gem.email = "ruby@simonhicks.org"
    gem.homepage = "http://github.com/simon-hicks/scails"
    gem.authors = ["simon-hicks"]
    gem.add_development_dependency "rspec"
    files_to_add = Dir[File.dirname(__FILE__) + '/lib/**/*.rb'].map{|f| f.gsub(File.dirname(__FILE__) + '/', '')}
    gem.files.include files_to_add
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError => e
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
  puts e
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "scails #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
