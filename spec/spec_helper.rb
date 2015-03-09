require 'coveralls'
Coveralls.wear!

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../spec/dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require "factory_girl_rails"
require "database_cleaner"
require 'shoulda/matchers/integrations/rspec'

require "viewmaster"


require File.expand_path("../../spec/support/schema", __FILE__)
require File.expand_path("../../spec/support/models", __FILE__)

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
end
