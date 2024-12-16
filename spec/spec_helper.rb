ENV["RACK_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

ActiveRecord::Migration.maintain_test_schema!
FactoryBot.find_definitions
