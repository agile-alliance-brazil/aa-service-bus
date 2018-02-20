# frozen_string_literal: true

%w[bundler find rake/testtask rspec/core/rake_task].each { |lib| require lib }

RSpec::Core::RakeTask.new(:spec)

task default: :spec
