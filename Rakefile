# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/extensiontask'
require 'rb_sys/extensiontask'

GEMSPEC = Gem::Specification.load('colordom.gemspec')

RbSys::ExtensionTask.new('colordom', GEMSPEC) do |ext|
  ext.lib_dir = 'lib/colordom'
end

task :native, [:platform] do |_t, platform:|
  sh 'bundle', 'exec', 'rb-sys-dock', '--platform', platform, '--build'
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: %i[clobber compile test]
