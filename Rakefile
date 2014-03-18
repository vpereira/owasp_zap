require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
      t.libs.push ["lib/zap","spec"]
      t.test_files = FileList['spec/*_spec.rb']
      t.verbose = true
end

namespace :test do
      desc "test coverage report"
      task :coverage do
        Rake::Task["test"].execute
      end
end

task :default=> :test
