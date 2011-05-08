require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require "rails/test_help"
  require 'rspec/rails'
  require 'migration_helper'
  require 'routing_helpers'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Rails.backtrace_cleaner.remove_silencers!

  Webrat.configure do |config|
    config.mode = :rails
  end

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec
    config.include MigrationHelpers
    config.include RoutingHelpers
    config.include RSpec::Matchers
    config.include Webrat::Matchers
    config.include Webrat::HaveTagMatcher
    config.include Rack::Test::Methods

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    config.before(:each) do
      drop_all_flex_tables
      User.destroy_all
      Attachment.destroy_all
      FlexTable.destroy_all
      DiskFile.destroy_all      
    end

  end

end

Spork.each_run do
  # This code will be run each time you run your specs.

end


