#!/usr/bin/env rake
begin
require 'bundler/setup'
  rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)

load 'rails/tasks/engine.rake'
Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }

require 'rspec/core'

require 'rspec/core/rake_task'

desc "Run all specs in spec directory (excluding plugin specs)"

#RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')

Rake::TestTask.new(:spec) do |t|
  t.libs << 'lib'
  t.libs << 'rspec'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = false
end

task :default => :spec