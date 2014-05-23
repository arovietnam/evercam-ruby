# Add to include paths.
$: << "#{Dir.getwd}/spec"

ENV['EVERCAM_ENV'] ||= 'test'

require 'bundler'
require 'cgi'
require 'minitest/autorun'
require 'simplecov'

Bundler.require(:default, :test)

# code coverage
SimpleCov.start do
  add_filter '/spec/'
end

RSpec.configure do |c|
  c.expect_with :stdlib, :rspec
  c.filter_run :focus => true
  c.filter_run_excluding skip: true
  c.run_all_when_everything_filtered = true
  c.mock_framework = :mocha
  c.fail_fast = true if ENV['FAIL_FAST']
end

# Stubbed requests
require 'webmock/rspec'

